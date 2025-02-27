package com.ashleytharp.uiwithfragmentspractice;

import android.app.Activity;
import android.os.Build;
import android.support.v4.app.ListFragment;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;


import com.ashleytharp.uiwithfragmentspractice.dummy.DummyContent;

/**
 * A fragment representing a list of Items.
 * <p/>
 * Large screen devices (such as tablets) are supported by replacing the ListView
 * with a GridView.
 * <p/>
 * Activities containing this fragment MUST implement the {@link OnFragmentInteractionListener}
 * interface.
 */
//public class HeadlinesFragment extends Fragment implements AbsListView.OnItemClickListener {
public class HeadlinesFragment extends ListFragment {

    private static final String TAG = "HeadlinesFragment";

    /**
     * Container activity must implement this interface
     */
    IOnHeadlineSelectedListener mHeadlineSelectedListener;

    /*// TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;
    */


    /**
     * The fragment's ListView/GridView.
     */
    private AbsListView mListView;

    /**
     * The Adapter which will be used to populate the ListView/GridView with
     * Views.
     */
    private ListAdapter mAdapter;

    // TODO: Rename and change types of parameters
    public static HeadlinesFragment newInstance(String param1, String param2) {
        HeadlinesFragment fragment = new HeadlinesFragment();
        Bundle args = new Bundle();
        //args.putString(ARG_PARAM1, param1);
        //args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }

    /**
     * Mandatory empty constructor for the fragment manager to instantiate the
     * fragment (e.g. upon screen orientation changes).
     */
    public HeadlinesFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //we need to se a different list item layout for devices olser than honey comb
        int layout = Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB ?
                android.R.layout.simple_list_item_activated_1 : android.R.layout.simple_list_item_1;

        //crate an array adapter for the list view, using the Ipsum headlines array
        setListAdapter(new ArrayAdapter<String>(getActivity(), layout, Ipsum.Headlines));

        //if (getArguments() != null) {
        //    mParam1 = getArguments().getString(ARG_PARAM1);
        //    mParam2 = getArguments().getString(ARG_PARAM2);
        //}

        // TODO: Change Adapter to display your content
        //mAdapter = new ArrayAdapter<DummyContent.DummyItem>(getActivity(),
        //        android.R.layout.simple_list_item_1, android.R.id.text1, DummyContent.ITEMS);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_item, container, false);

        // Set the adapter
        mListView = (AbsListView) view.findViewById(android.R.id.list);
        ((AdapterView<ListAdapter>) mListView).setAdapter(mAdapter);

        // Set OnItemClickListener so we can be notified on item clicks
       // mListView.setOnItemClickListener(this);

        return view;
    }

    @Override
    public void onAttach(Activity activityThisFragmentWasAttachedTo) {
        super.onAttach(activityThisFragmentWasAttachedTo);

        //the container activity must implement the IOnHeadlineSelectedListener interface (callback)
        //this makes sense because any class that contains this headlines fragment is going to have to handle what happens
        //when a headline is selected
        try{
            //if we throw an error it means that whatever Fragment this HeadlinesFragment has been attached to doesnt
            //implement the IOnHeadlineSelectedListener. That's bad, we only want to be attached to Fragments that implement that
            //listener mmmmkay?
            mHeadlineSelectedListener = (IOnHeadlineSelectedListener)activityThisFragmentWasAttachedTo;
        }catch(ClassCastException classCastException){
            throw new ClassCastException(activityThisFragmentWasAttachedTo.toString() + "must implement onHeadlineSelectedListener or else this HeadlinesFragment cannot be attached to it");
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mHeadlineSelectedListener = null;
    }

    @Override
    public void onStart(){
        super.onStart();

        //when in two pane layout, set the listview to highlight the selected list item
        if(getFragmentManager().findFragmentById(R.id.fragment_article) != null){
            getListView().setChoiceMode(ListView.CHOICE_MODE_SINGLE);
        }
    }

    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        //if (null != mListener) {
            // Notify the active callbacks interface (the activity, if the
            // fragment is attached to one) that an item has been selected.
            //mListener.onFragmentInteraction(DummyContent.ITEMS.get(position).id);
        //}
        if(mHeadlineSelectedListener == null){
            Log.e(TAG, "ERROR: HeadlinesFragment has not been attached to any activity.  In order to attach a callback to an article click, please attach the HeadlinesFragment to a parent activity before handling any callbacks on clicks.");
        }else{
            //if an article has been selected, we are going to use the callback we made to notify the parent activity.
            mHeadlineSelectedListener.onArticleSelected(position);
        }
    }

    /**
     * The default content for this Fragment has a TextView that is shown when
     * the list is empty. If you would like to change the text, call this method
     * to supply the text it should use.
     */
    public void setEmptyText(CharSequence emptyText) {
        View emptyView = mListView.getEmptyView();

        if (emptyView instanceof TextView) {
            ((TextView) emptyView).setText(emptyText);
        }
    }

    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p/>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        public void onFragmentInteraction(String id);
    }

}
