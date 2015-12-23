/**
 * sugar.i
 *
 * Helper macros to implement .net collections and other assorted syntactic sugar
 */

%define IMPLEMENT_LIST(collection_type, item_type)
//Necessary imports
%typemap(csimports) collection_type %{
using System;
using System.Reflection;
using System.Collections;
using System.Collections.Generic;
%}
//Collection Interfaces implemented by the implementing proxy class
%typemap(csinterfaces_derived) collection_type "IList<item_type>"
//This is the IList<T> implementation that is injected into the implementing proxy class
%typemap(cscode) collection_type %{
    /*
    int IList<item_type>.IndexOf(item_type item)
    {
        return this.IndexOf(item);
    }
    
    void IList<item_type>.Insert(int index, item_type item)
    {
        this.Insert(index, item);
    }
    
    void IList<item_type>.RemoveAt(int index)
    {
        this.RemoveAt(index);
    }
    */
    public item_type this[int index]
    {
        get { return this.GetItem(index); }
        set { this.SetItem(index, value); }
    }
    /*
    void ICollection<item_type>.Add(item_type item)
    {
        this.Add(item);
    }
    
    void ICollection<item_type>.Clear()
    {
        this.Clear();
    }
    
    bool ICollection<item_type>.Contains(item_type item)
    {
        return this.Contains(item);
    }
    */
    public void CopyTo(item_type[] array, int arrayIndex)
    {
        throw new global::System.NotImplementedException();
    }
    
    bool ICollection<item_type>.Remove(item_type item)
    {
        int count = this.GetCount();
        this.Remove(item);
        return this.GetCount() < count;
    }
    
    public int Count
    {
        get { return this.GetCount(); }
    }
    
    public bool IsReadOnly
    {
        get { return false; }
    }
    
    class CollectionEnumerator : IEnumerator<item_type>
    {
        private IList<item_type> _list;
        private int _position;
        private int _count;
        
        public CollectionEnumerator(IList<item_type> list)
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
        
        item_type IEnumerator<item_type>.Current
        {
            get { return _list[_position]; }
        }
        
        public void Dispose() { }
    }
    
    public IEnumerator<item_type> GetEnumerator()
    {
        return new CollectionEnumerator(this);
    }
    
    IEnumerator IEnumerable.GetEnumerator()
    {
        return new CollectionEnumerator(this);
    }
%}
%enddef
%define IMPLEMENT_READONLY_LIST(collection_type, item_type)
//Necessary imports
%typemap(csimports) collection_type %{
using System;
using System.Reflection;
using System.Collections;
using System.Collections.Generic;
%}
//Collection Interfaces implemented by the implementing proxy class
%typemap(csinterfaces_derived) collection_type "IReadOnlyList<item_type>"
//This is the IReadOnlyList<T> implementation that is injected into the implementing proxy class
%typemap(cscode) collection_type %{
    item_type IReadOnlyList<item_type>.this[int index]
    {
        get { return this.GetItem(index); }
    }
    
    int IReadOnlyCollection<item_type>.Count
    {
        get { return this.GetCount(); }
    }
    
    class CollectionEnumerator : IEnumerator<item_type>
    {
        private IReadOnlyList<item_type> _list;
        private int _position;
        private int _count;
        
        public CollectionEnumerator(IReadOnlyList<item_type> list)
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
        
        item_type IEnumerator<item_type>.Current
        {
            get { return _list[_position]; }
        }
        
        public void Dispose() { }
    }
    
    IEnumerator<item_type> IEnumerable<item_type>.GetEnumerator()
    {
        return new CollectionEnumerator(this);
    }
    
    IEnumerator IEnumerable.GetEnumerator()
    {
        return new CollectionEnumerator(this);
    }
%}
%enddef