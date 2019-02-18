#define MAXSIZE 1000
struct stack
{
    char stk[MAXSIZE][50];
    int top ;
};
typedef struct stack STACK;
STACK place={.top=0};
STACK activation={.top=0};
 
void push(char* num);
void pop(void);
void display(void);
int SP;
int deltap;
int L;

/*  Function to add an element to the stack */
void push (char* num)
{
    
    if (place.top == (MAXSIZE - 1))
    {
        printf ("Stack is Full\n");
        return;
    }
    else
    {
	place.top = place.top + 1;
        
        //place.stk[place.top] = num;
	int i =0;
	while(num[i]!='\0')                                                   
   	 {
        	place.stk[place.top][i] = num[i];                                                    
        	i++;
    	 }
	 place.stk[place.top][i] = num[i];  
	 
    }
    return;
}
/*  Function to delete an element from the stack */
void pop ()
{
    char* num;
    if (place.top == - 1)
    {
        printf ("Stack is Empty\n");
        
    }
    else
    {
        //num = place.stk[place.top];
        //printf ("poped element is = %sn", place.stk[place.top]);
        place.top = place.top - 1;
    }
    //return(num);
}
/*  Function to display the status of the stack */
void display ()
{
    int i;
    if (place.top == -1)
    {
        printf ("Stack is empty\n");
        return;
    }
    else
    {
        printf ("\n The status of the stack is %d \n",place.top);
        for (i = place.top; i > 0; i--)
        {
	    int j = 0;
            //printf ("%s\n", place.stk[i]);
	    for (j = 0; place.stk[i][j] != '\0'; j++)
		{
			printf ("%c\n", place.stk[i][j]);
		}
        
        }
    }
    printf ("\n");
}


void apush (char* num)
{
    
    if (activation.top == (MAXSIZE - 1))
    {
        printf ("Stack is Full\n");
        return;
    }
    else
    {
	activation.top = activation.top + 1;
        
        //place.stk[place.top] = num;
	int i =0;
	while(num[i]!='\0')                                                   
   	 {
        	activation.stk[activation.top][i] = num[i];                                                    
        	i++;
    	 }
	 activation.stk[activation.top][i] = num[i];  
	 
    }
    return;
}
/*  Function to delete an element from the stack */
void apop ()
{
    char* num;
    if (activation.top == - 1)
    {
        printf ("Stack is Empty\n");
        
    }
    else
    {
        //num = place.stk[place.top];
        //printf ("poped element is = %sn", place.stk[place.top]);
        activation.top = activation.top - 1;
    }
    //return(num);
}
/*  Function to display the status of the stack */
void adisplay ()
{
    int i;
    if (activation.top == -1)
    {
        printf ("Stack is empty\n");
        return;
    }
    else
    {
        printf ("\n The status of the stack is %d \n",activation.top);
        for (i = activation.top; i > 0; i--)
        {
	    int j = 0;
            //printf ("%s\n", place.stk[i]);
	    for (j = 0; activation.stk[i][j] != '\0'; j++)
		{
			printf ("%c\n", activation.stk[i][j]);
		}
        
        }
    }
    printf ("\n");
}
