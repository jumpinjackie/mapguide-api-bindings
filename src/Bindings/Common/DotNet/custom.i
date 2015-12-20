// MgBatchPropertyCollection

%typemap(csimports) MgBatchPropertyCollection %{
using System;
using System.Reflection;
using System.Collections;
using System.Collections.Generic;
%}

%typemap(csinterfaces_derived) collection_type "IList<MgPropertyCollection>"

%typemap(cscode) collection_type %{
    int IList<MgPropertyCollection>.IndexOf(MgPropertyCollection item)
    {
        return -1;
    }
    
    void IList<MgPropertyCollection>.Insert(int index, MgPropertyCollection item)
    {
        this.Insert(index, item);
    }
    
    void IList<MgPropertyCollection>.RemoveAt(int index)
    {
        this.RemoveAt(index);
    }
    
    MgPropertyCollection IList<MgPropertyCollection>.this[int index]
    {
        get { return this.GetItem(index); }
        set { this.SetItem(index, value); }
    }
    
    void ICollection<MgPropertyCollection>.Add(MgPropertyCollection item)
    {
        this.Add(item);
    }
    
    void ICollection<MgPropertyCollection>.Clear()
    {
        this.Clear();
    }
    
    bool ICollection<MgPropertyCollection>.Contains(MgPropertyCollection item)
    {
        return false;
    }
    
    void ICollection<MgPropertyCollection>.CopyTo(MgPropertyCollection[] array, int arrayIndex)
    {
        throw new global::System.NotImplementedException();
    }
    
    bool ICollection<MgPropertyCollection>.Remove(MgPropertyCollection item)
    {
        int count = this.GetCount();
        this.Remove(item);
        return this.GetCount() < count;
    }
    
    int ICollection<MgPropertyCollection>.Count
    {
        get { return this.GetCount(); }
    }
    
    bool ICollection<MgPropertyCollection>.IsReadOnly
    {
        get { return false; }
    }
    
    class CollectionEnumerator : IEnumerator<MgPropertyCollection>
    {
        private IList<MgPropertyCollection> _list;
        private int _position;
        private int _count;
        
        public CollectionEnumerator(IList<MgPropertyCollection> list)
        {
            _list = list;
            _count = list.Count;
            _position = -1;
        }
        
        bool IEnumerator.MoveNext()
        {
            _position++;
            return _position < _count;
        }
        
        void IEnumerator.Reset()
        {
            _position = -1;
        }
        
        object IEnumerator.Current
        {
            get { return _list[_position]; }
        }
        
        MgPropertyCollection IEnumerator<MgPropertyCollection>.Current
        {
            get { return _list[_position]; }
        }
        
        public void Dispose() { }
    }
    
    IEnumerator<MgPropertyCollection> IEnumerable<MgPropertyCollection>.GetEnumerator()
    {
        return new CollectionEnumerator(this);
    }
    
    IEnumerator IEnumerable.GetEnumerator()
    {
        return new CollectionEnumerator(this);
    }
%}