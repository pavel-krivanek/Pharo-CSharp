Class {
	#name : 'PharoCSharpTest',
	#superclass : 'TestCase',
	#category : 'Pharo CSharp-Tests',
	#package : 'Pharo CSharp-Tests'
}

{ #category : 'tests' }
PharoCSharpTest >> convert: aMethod [ 

	| visitor printer |
	visitor := PharoCSharpASTBuildingVisitor new.
	visitor visitMethod: aMethod.
	printer := PharoCSharpPrintingVisitor new 
		visitMethodNode: visitor ast.
	^ printer contents.

]

{ #category : 'tests' }
PharoCSharpTest >> msg [

 #(returns: (Array of String)). 
]

{ #category : 'tests' }
PharoCSharpTest >> test: aMethod equals: aString [ 

	^ self assert: (self convert: aMethod) trimBoth withSeparatorsCompacted equals: aString trimBoth withSeparatorsCompacted 
]

{ #category : 'tests' }
PharoCSharpTest >> testAnd [

	self test: PharoCSharpTestClass>>#and equals: '
public long And()
{
    if ((true && false))
    {
        return 1L;
    }
    if ((SomeMessage() && OtherMessage()))
    {
        return 1L;
    }
    return 0L;
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testAssociation [

	self test: PharoCSharpTestClass>>#association equals: '
public long Association()
{
    Association<string, string> assoc;
    assoc = new Association<string, string>("someKey", "some value");
    return 0L;
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testAtIfAbsent [

	self test: PharoCSharpTestClass>>#atIfAbsent equals: '
public long AtIfAbsent()
{
    string tmp;
    Dictionary<string, string> dict;
    dict = new Dictionary<string, string>();
    tmp = dict.At("test", ifAbsent: () => dict.At("another", ifAbsent: () => "missing"));
    return 0L;
}


'
]

{ #category : 'tests' }
PharoCSharpTest >> testAtIfAbsent2 [

	self test: PharoCSharpTestClass>>#atIfAbsent2 equals: '
public long AtIfAbsent2()
{
    string tmp;
    Dictionary<string, string> dict;
    Dictionary<long, long> help;
    dict = new Dictionary<string, string>();
    tmp = dict.At("test", ifAbsent: () => dict.At("another", ifAbsent: () => help = new Dictionary<long, long>()));
    tmp = dict.At("test", ifAbsent: () => dict.At("another", ifAbsent: () => (help = new Dictionary<long, long>()).ToString()));
    return 0L;
}


'
]

{ #category : 'tests' }
PharoCSharpTest >> testBinaryConversion [

	self test: PharoCSharpTestClass>>#binaryConversion equals: '
public long BinaryConversion()
{
    unknown s;
    s.NextPutAll("test");
    s.NextPutAll("test 2").NextPutAll("test 3");
    if ((s.NextPutAll("test 4")))
    {
        return 1L;
    }
    return 0L;
}
'
]

{ #category : 'tests' }
PharoCSharpTest >> testBinaryConversion2 [

	self test: PharoCSharpTestClass>>#binaryConversion2 equals: '
public long BinaryConversion2()
{
    unknown s;
    unknown temp;
    s.NextPutAll((temp ?? 0L).ToString());
    return 0L;
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testBlockType [ 

	 | block visitor type | 
	
	visitor := PharoCSharpASTBuildingVisitor new.
	block := RBParser parseExpression: '[ ]'.
	type := visitor blockReturnTypeOrNilOf: block.
	self assert: type isNil.
	
	block := RBParser parseExpression: '[ #(returns: String). ]'.
	type := visitor blockReturnTypeOrNilOf: block.
	self assert: type anyOne typeClass equals: String.	

	block := RBParser parseExpression: '[ #(returns: Void). ]'.
	type := visitor blockReturnTypeOrNilOf: block.
	self assert: type anyOne typeClass equals: Void.	

	block := RBParser parseExpression: '[ #(returns: (Array of String)). ]'.
	type := visitor blockReturnTypeOrNilOf: block.
	self assert: type anyOne typeClass equals: Array.	
	self assert: type anyOne itemClasses anyOne typeClass equals: String.	
	
	block := RBParser parseExpression: '[ 42 ]'.
	type := visitor blockReturnTypeOrNilOf: block.
	self assert: type isNil.
	
	block := RBParser parseExpression: '[ #(returns:). ]'.
	type := visitor blockReturnTypeOrNilOf: block.
	self assert: type isEmpty 
]

{ #category : 'tests' }
PharoCSharpTest >> testBlocksReturningValues [

	self test: PharoCSharpTestClass>>#blocksReturningValues equals: '
public long BlocksReturningValues()
{
    "string".BlockMessage((unknown each) => {
        each.Yourself();
        return (each + 1L);
    }
);
    "string".BlockMessage((unknown each) => {
        each.Yourself();
        (each + 2L);
    }
);
    foreach (unknown each in "string")
    {
        each.Yourself();
        (each + 3L);
    }
    "string".Where((unknown each) => {
        each.Yourself();
        return (each + 4L);
    }
).ToList();
    return 0L;
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testCascade [

	self test: PharoCSharpTestClass>>#cascade equals: '
public unknown Cascade()
{
    unknown temp;
    var cascade = new String();
    cascade.Alike("def");
    var cascade2 = new String();
    cascade2.AsComment();
    cascade2.Alike("abc");
    temp = Max((cascade2), min: (cascade));
    return 0L;
}

	
'
]

{ #category : 'tests' }
PharoCSharpTest >> testCascadeInsideBlock [

	self test: PharoCSharpTestClass>>#cascadeInsideBlock equals: '
public string CascadeInsideBlock()
{
    return PharoString.StreamContents((unknown s) => {
		var cascade = s;
	    cascade.NextPutAll("Hello");
	    cascade.NextPutAll((" World" + "!"));
	} );
}
	
	
'
]

{ #category : 'tests' }
PharoCSharpTest >> testCast [

	self test: PharoCSharpTestClass>>#cast equals: '
public long Cast()
{
    long num;
    num = (long)Yourself();
    num = Yourself() as List<long>;
    return 0L;
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testCollect [

	self test: PharoCSharpTestClass>>#collect equals: '
public List<long> Collect()
{
    return Select((long each) => (each + 1L)).ToList();
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testCopyFromTo [

	self test: PharoCSharpTestClass>>#copyFromTo equals: '
public long CopyFromTo()
{
    List<long> aCollection;
    PharoCollection.CopyFrom(aCollection, from: 2L, to: 3L);
    return 0L;
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testDo [

	self test: PharoCSharpTestClass>>#do equals: '
public long Do()
{
    foreach (long each in this)
    {
        (each + 1L);
    }
    return 0L;
}
'
]

{ #category : 'tests' }
PharoCSharpTest >> testDoWithIndex [

	self test: PharoCSharpTestClass>>#doWithIndex equals: '
public long DoWithIndex()
{
    List<string> aCollection;
    for (long index = 1; index <= aCollection.Count(); index++)
    {
        string each = aCollection[(int)index-1];
        (each + index);
    }
    return 0L;
}
'
]

{ #category : 'tests' }
PharoCSharpTest >> testIf [

	self test: PharoCSharpTestClass>>#if equals: '
public long If()
{
    long a;
    a = 0L;
    if (true)
    {
        a = (a + 1L);
        return 1L;
    }
    return 0L;
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testImplicitReturn [

	self test: PharoCSharpTestClass>>#implicitReturn equals: '
public PharoCSharpTestClass ImplicitReturn()
{
	return this;
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testIsKindOf [

	self test: PharoCSharpTestClass>>#isKindOf equals: '
public long IsKindOf()
{
    Collection tmp;
    if ((tmp is Collection))
    {
        return 1L;
    }
    return 0L;
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testKeysAndValuesDo [

	self test: PharoCSharpTestClass>>#keysAndValuesDo equals: '
public long KeysAndValuesDo()
{
    Dictionary<string, long> aCollection;
    foreach (var kvp in aCollection)
    {
        string k = kvp.Key;
        long v = kvp.Value;
        return v;
    }
    return 0L;
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testLambda1 [

	self test: PharoCSharpTestClass>>#lambda1 equals: '
public long Lambda1()
{
    Message().Where((unknown each) => (each + 1L)).ToList();
    Message().Where((unknown each) => {
        each.ToString();
        return (each + 1L);
    } ).ToList();
    return 0L;
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testModulo [

	self test: PharoCSharpTestClass>>#modulo equals: '
public long Modulo()
{
    return (20L % 3L);
}


'
]

{ #category : 'tests' }
PharoCSharpTest >> testNew [

	self test: PharoCSharpTestClass>>#newMessage equals: '
public Dictionary<string, long> NewMessage()
{
    List<long> array;
    new Object();
    new Object().ToString();
    new this();
    new this();
    array = new List<long>();
    return new Dictionary<string, long>();
}


'
]

{ #category : 'tests' }
PharoCSharpTest >> testNonLocalReturn [

	self test: PharoCSharpTestClass>>#nonLocalReturn equals: '
public bool NonLocalReturn()
{
    if (true)
    {
        return true;
    }
    return false;
}
'
]

{ #category : 'tests' }
PharoCSharpTest >> testNullable [

	self test: PharoCSharpTestClass>>#nullable equals: '
public long Nullable()
{
    long? a;
    long? b;
    a = null;
    a = 0L;
    b = null;
    b = 0L;
    return 0L;
}


'
]

{ #category : 'tests' }
PharoCSharpTest >> testOnDo [

	self test: PharoCSharpTestClass>>#nonOnDo equals: '
public long NonOnDo()
{
    try {
        42L;
    }
    catch (Exception err)
    {
        "something";
    }
    try {
        42L;
    }
    catch (Exception _)
    {
        "something";
    }
    return 0L;
}
'
]

{ #category : 'tests' }
PharoCSharpTest >> testOr [

	self test: PharoCSharpTestClass>>#or equals: '
public long Or()
{
    if ((true || false))
    {
        return 1L;
    }
    if ((SomeMessage() || OtherMessage()))
    {
        return 1L;
    }
    return 0L;
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testOrderedCollection01 [

	self test: PharoCSharpTestClass>>#orderedCollection01 equals: '
public long OrderedCollection01()
{
    List<long> temp;
    temp = new List<long>();
    temp.Add(1L);
    return 0L;
}
'
]

{ #category : 'tests' }
PharoCSharpTest >> testPharoCSharp [

	self test: PharoCSharpTestClass>>#pharoCSharp equals: '
public long PharoCSharp()
{
    long tmp;
    Console.WriteLine(Hello World!);
    tmp = "in C#";
    return 0L;
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testPrecedence [

	self test: PharoCSharpTestClass>>#precedence equals: '
public long Precedence()
{
    return ((2L + 5L) * 6L);
}


	
	
'
]

{ #category : 'tests' }
PharoCSharpTest >> testSelect [

	self test: PharoCSharpTestClass>>#select equals: '
public List<long> Select()
{
    return Message().Where((long each) => (each + 1L)).ToList();
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testSelfInBinary [

	self test: PharoCSharpTestClass>>#selfInBinary equals: '
public bool SelfInBinary()
{
    return (this == true);
}


'
]

{ #category : 'tests' }
PharoCSharpTest >> testStreamContents [

	self test: PharoCSharpTestClass>>#streamContents equals: '
public string StreamContents()
{
    return PharoString.StreamContents((WriteStream s) => s.NextPutAll("hello"));
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testTernary [

	self test: PharoCSharpTestClass>>#ternary equals: '
public long Ternary()
{
    unknown tmp;
    tmp = true ? "true" : "false";
    tmp = true ? "true" : "false";
    tmp = true ? "true" : null;
    tmp = true ? null : "false";
    tmp = true ?? "isNil";
    tmp = (true == null) ? null : "notNil";
    var arg = true;
    tmp = (arg == null) ? null : arg;
    tmp = (true != null) ? "notNil" : "isNil";
    var arg = true;
    tmp = (arg != null) ? arg : "isNil";
    tmp = (true == null) ? "isNil" : "notNil";
    var arg = true;
    tmp = (arg == null) ? "isNil" : arg;
    tmp = !true.Any() ? "empty" : "notEmpty";
    var arg = true;
    tmp = !arg.Any() ? "empty" : arg;
    tmp = true.Any() ? "notEmpty" : "empty";
    var arg = true;
    tmp = arg.Any() ? arg : "empty";
    var temporary = true;
    tmp = !temporary.Any() ? "empty" : temporary;
    var temporary2 = true;
    tmp = temporary2.Any() ? "notEmpty" : temporary2;
    return 0L;
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testTernaryInBlockNotReturningValue [

	self test: PharoCSharpTestClass>>#ternaryInBlockNotReturningValue equals: '
public PharoCSharpTestClass TernaryInBlockNotReturningValue()
{
    object nonDict;
    long temp;
    nonDict.KeysAndValuesDo((unknown k, unknown v) => if ((temp == 1L)) { 2L; } );
    return this;
}

'
]

{ #category : 'tests' }
PharoCSharpTest >> testWhileTrue [

	self test: PharoCSharpTestClass>>#whileTrue equals: '
public long WhileTrue()
{
    long a;
    a = 0L;
    while (true)
    {
        a = (a + 1L);
        a = (a - 1L);
    }
    return 0L;
}


'
]

{ #category : 'tests' }
PharoCSharpTest >> testWithIndexDo [

	self test: PharoCSharpTestClass>>#withIndexDo equals: '
public long WithIndexDo()
{
    List<string> aCollection;
    for (long index = 1; index <= aCollection.Count(); index++)
    {
        string each = aCollection[(int)index-1];
        (each + index);
    }
    return 0L;
}
'
]
