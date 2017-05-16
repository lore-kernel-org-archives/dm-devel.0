From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath-tools:Prioritizer based on a
 time-delay algorithm
Date: Tue, 16 May 2017 16:38:50 -0500
Message-ID: <20170516213850.GO22856@octiron.msp.redhat.com>
References: <1494215904-7564-1-git-send-email-philip.yang@huawei.com>
	<1494501243.6093.16.camel@suse.com>
	<aec35be2-fa7f-1fc8-9cd8-a52647cddc13@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <aec35be2-fa7f-1fc8-9cd8-a52647cddc13@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yang Feng <philip.yang@huawei.com>
Cc: zouming.zouming@huawei.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, guanjunxiong@huawei.com, shenhong09@huawei.com, dm-devel@redhat.com, hege09@huawei.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On Mon, May 15, 2017 at 06:44:47PM +0800, Yang Feng wrote:
> Please find the up-to-date patch below:
> 

First, one overall question. We have dynamic path selectors available to
deal with paths that are just simply slower that other paths, but can
still be used together.  Is there specific hardware or a specific setup
where this isn't good enough and we really need to seperate these paths
into different pathgroups, but we can't find out deterministically how
the groups should be set up?  It just seems like there could be a less
hacky solution to this problem, but perhaps there are some situations
where this is truly the best option. I'm just wondering what those are.

other commenets inlined

> ---
> >From 1a9426dfbad00b5dbefc7020603e40e8896e4869 Mon Sep 17 00:00:00 2001
> From: Yang Feng <philip.yang@huawei.com>
> Date: Mon, 15 May 2017 18:33:29 +0800
> Subject: [PATCH] [dm-devel] [PATCH] multipath-tools:Prioritizer based on a time-delay algorithm
>  Prioritizer for device mapper multipath, where the corresponding priority values of specific paths are provided by a time-delay
>  algorithm. And the time-delay algorithm is dependent on the following arguments(delay_interval, cons_num). The principle of the
>  algorithm is illustrated as follows:
>  1. By sending a certain number "cons_num" of read IOs to the current path    continuously, the IOs' average delay can be calculated.
>  2. According to the average delay of each path and the weight value "delay_interval", the priority "rc" of each path can be provided.
> 
>            delay_interval  delay_interval  delay_interval      delay_interval
> 	 |---------------|---------------|---------------|   |---------------|
> 	 |priority rank 1|priority rank 2|priority rank 3|...|priority rank x|
>          |---------------|---------------|---------------|   |---------------|
> 		               Priority Rank Partitioning
> ---
>  libmultipath/prioritizers/Makefile      |   6 +-
>  libmultipath/prioritizers/delayedpath.c | 261 ++++++++++++++++++++++++++++++++
>  libmultipath/prioritizers/delayedpath.h |  17 +++
>  multipath/multipath.conf.5              |  19 +++
>  4 files changed, 302 insertions(+), 1 deletion(-)
>  create mode 100644 libmultipath/prioritizers/delayedpath.c
>  create mode 100644 libmultipath/prioritizers/delayedpath.h
> 
> diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
> index 36b42e4..8df5234 100644
> --- a/libmultipath/prioritizers/Makefile
> +++ b/libmultipath/prioritizers/Makefile
> @@ -18,13 +18,17 @@ LIBS = \
>  	libpriorandom.so \
>  	libpriordac.so \
>  	libprioweightedpath.so \
> -	libpriosysfs.so
> +	libpriodelayedpath.so \
> +	libpriosysfs.so
> 
>  all: $(LIBS)
> 
>  libprioalua.so: alua.o alua_rtpg.o
>  	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> 
> +libpriodelayedpath.so: delayedpath.o  ../checkers/libsg.o
> +	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> +
>  libprio%.so: %.o
>  	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> 
> diff --git a/libmultipath/prioritizers/delayedpath.c b/libmultipath/prioritizers/delayedpath.c
> new file mode 100644
> index 0000000..0490e8d
> --- /dev/null
> +++ b/libmultipath/prioritizers/delayedpath.c
> @@ -0,0 +1,261 @@
> +/*
> + * (C) Copyright HUAWEI Technology Corp. 2017, 2021   All Rights Reserved.
> + *
> + * main.c
> + *
> + * Prioritizer for device mapper multipath, where the corresponding priority
> + * values of specific paths are provided by a time-delay algorithm. And the
> + * time-delay algorithm is dependent on arguments.
> + *
> + * The principle of the algorithm as follows:
> + * 1. By sending a certain number "cons_num" of read IOs to the current path
> + *    continuously, the IOs' average delay can be calculated.
> + * 2. According to the average delay of each path and the weight value
> + *    "delay_interval", the priority "rc" of each path can be provided.
> + *
> + * Author(s): Yang Feng <philip.yang@huawei.com>
> + *            Zou Ming <zouming.zouming@huawei.com>
> + *
> + * This file is released under the GPL.
> + */
> +#include <stdio.h>
> +#include <ctype.h>
> +#include <time.h>
> +
> +#include "debug.h"
> +#include "prio.h"
> +#include "structs.h"
> +#include "../checkers/libsg.h"
> +
> +#include "delayedpath.h"
> +
> +#define THRES_USEC_VALUE        300000000LL    /*USEC, 300SEC*/
> +#define DEFAULT_DELAY_INTERVAL  10             /*MSEC*/
> +#define DEFAULT_CONS_NUM        20
> +
> +#define MAX_CHAR_SIZE           30
> +
> +#define CHAR_SEC                "s"
> +#define CHAR_MSEC               "ms"
> +#define CHAR_USEC               "us"
> +
> +enum interval_type {
> +    INTERVAL_SEC,
> +    INTERVAL_MSEC,
> +    INTERVAL_USEC,
> +    INTERVAL_INVALID
> +};
> +
> +/* interval_unit_str and interval_unit_type keep the same assignment sequence */
> +static const char interval_unit_str[][MAX_CHAR_SIZE] = {
> +    CHAR_USEC, CHAR_MSEC, CHAR_SEC

This is a nit, but for constant strings, could you please use "char
*var" instead of "char var[]", to be consistent with the rest of the
multipath code.

> +};
> +static const int interval_unit_type[] = {
> +    INTERVAL_USEC, INTERVAL_MSEC, INTERVAL_SEC
> +};
> +
> +static const int conversion_ratio[] = {
> +	[INTERVAL_SEC]		= USEC_PER_SEC,
> +	[INTERVAL_MSEC]	        = USEC_PER_MSEC,
> +	[INTERVAL_USEC]		= USEC_PER_USEC,
> +	[INTERVAL_INVALID]	= 0
> +};
> +
> +
> +static int do_readsector0(int fd, unsigned int timeout)
> +{
> +	unsigned char buf[4096];
> +	unsigned char sbuf[SENSE_BUFF_LEN];
> +	int ret;
> +
> +	ret = sg_read(fd, &buf[0], 4096, &sbuf[0],
> +		      SENSE_BUFF_LEN, timeout);
> +
> +	return ret;
> +}
> +
> +static int get_interval_type(char *source, char *type)
> +{
> +    char *p;
> +    int size;
> +    int i;
> +
> +    for (i = 0; i < sizeof(interval_unit_str)/MAX_CHAR_SIZE; i++)
> +    {
> +        size = strlen(interval_unit_str[i]);
> +        p = strstr(source, interval_unit_str[i]);
> +        if (p != NULL && p[size] == '|')
> +        {
> +            memcpy(type, interval_unit_str[i], size+1);
> +            return interval_unit_type[i];
> +        }
> +    }
> +
> +    return INTERVAL_INVALID;
> +}
> +
> +/* In multipath.conf, args form: delay_interval|cons_num. For example,
> +*  args is "10ms|20", this function can get 10, ms, and 20.
> +*/
> +static int get_digit_and_type(char *args,
> +                              int *interval,
> +                              int *consnum,
> +                              int *type)
> +{
> +    char typestr[MAX_CHAR_SIZE];
> +    char source[MAX_CHAR_SIZE];
> +    char vertica[] = "|";
> +    char *tokenbefore = NULL;
> +    char *tokenafter = NULL;
> +    char *tmp = NULL;
> +    unsigned int size = strlen(args);
> +
> +    if ((args == NULL) || (interval == NULL)
> +        || (consnum == NULL) || (type == NULL))
> +        return 0;
> +
> +    /* int type */
> +    if ((size < 1) || (size > MAX_CHAR_SIZE-1))
> +        return 0;

You should probably have log messages for these error returns.

> +
> +    memcpy(source, args, size+1);
> +    if (strstr(source, vertica) == NULL)
> +        return 0;
> +
> +    *type = get_interval_type(source, typestr);
> +    if (*type == INTERVAL_INVALID)
> +    {
> +        condlog(0, "delay_interval type is invalid");
> +        return 0;
> +    }

I'm confused here. How do you get to use the default interval. Shouldn't
you accept "20s|" and "|30" and as valid inputs that use the defaults
for the part they don't specify. 

> +    tokenbefore = strtok(source, vertica);
> +    tokenafter = strtok(NULL, vertica);
> +    typestr[1] = '\0';
> +    tokenbefore = strtok(tokenbefore, typestr);
> +    if ((tokenbefore == NULL) || (tokenafter == NULL))
> +        return 0;
> +
> +    tmp = tokenbefore;
> +    while (*tmp != '\0')
> +        if (!isdigit(*tmp++))
> +        {
> +            condlog(0, "delay_interval string include invalid char");
> +            return 0;
> +        }
> +
> +    tmp = tokenafter;
> +    while (*tmp != '\0')
> +        if (!isdigit(*tmp++))
> +        {
> +            condlog(0, "cons_num string include invalid char");
> +            return 0;
> +        }
> +
> +    *interval = atoi(tokenbefore);

Why do you keep track of the type and the interval seperately? Can't you
just find out the type, and use that to multiply the interval once you
read it, and then just use that value, instead of keeping track of two
values across multiple functions?

> +    *consnum = atoi(tokenafter);
> +
> +    return 1;
> +}
> +
> +int check_args_valid(int delay_interval, int cons_num, int type)
> +{
> +    if (type == INTERVAL_SEC)
> +    {
> +        if ((delay_interval < 1) || (delay_interval > 60))
> +        {
> +            condlog(0, "delay_interval values is invalid");
> +            return 0;
> +        }
> +    }
> +    else if (type != INTERVAL_INVALID)
> +    {
> +        if ((delay_interval < 1) || (delay_interval >= 1000))
> +        {
> +            condlog(0, "delay_interval values is invalid");
> +            return 0;
> +        }
> +    }
> +
> +    if ((cons_num < 3) || (cons_num > 1000))
> +    {
> +        condlog(0, "cons_num values is invalid");
> +        return 0;
> +    }
> +
> +    return 1;
> +}
> +
> +int get_delay_pref_arg(char *args, int *delay_interval, int *cons_num, int *interval_type)
> +{
> +    if (get_digit_and_type(args, delay_interval, cons_num, interval_type) == 0)
> +        return 0;
> +
> +    if (check_args_valid(*delay_interval, *cons_num, *interval_type) == 0)
> +        return 0;
> +
> +    return 1;
> +}
> +
> +long long get_conversion_ratio(int type)
> +{
> +    return conversion_ratio[type];
> +}
> +
> +int getprio (struct path *pp, char *args, unsigned int timeout)
> +{
> +    int rc, delay_interval, cons_num, type, temp;
> +    long long delay, avgdelay, ratio;
> +    long long min = THRES_USEC_VALUE;
> +    long long max = 0;
> +    long long toldelay = 0;
> +    long long before, after;
> +    struct timespec tv;
> +
> +	if (pp->fd < 0)
> +	    return -PRIO_NO_INFORMATION;
> +
> +    if (get_delay_pref_arg(args, &delay_interval, &cons_num, &type) == 0)
> +    {
> +        condlog(3, "%s: get delay arg fail", pp->dev);

Why use the word "fail" in this message? Not setting prio_args to get
the defaults seems like a perfectly valid choice.

> +        delay_interval = DEFAULT_DELAY_INTERVAL;
> +        cons_num = DEFAULT_CONS_NUM;
> +        type = INTERVAL_MSEC;
> +    }
> +
> +    temp = cons_num;
> +    while (temp-- > 0)
> +    {
> +        (void)clock_gettime(CLOCK_MONOTONIC, &tv);
> +        before = timeval_to_us(&tv);		
> +
> +        if (do_readsector0(pp->fd, timeout) == 2)
> +        {
> +            condlog(0, "%s: path down", pp->dev);
> +            return -1;
> +        }
> +
> +        (void)clock_gettime(CLOCK_MONOTONIC, &tv);
> +        after = timeval_to_us(&tv);
> +
> +        delay = after - before;
> +    	
> +        min = (min <= delay) ? min : delay;
> +        max = (max >= delay) ? max : delay;
> +
> +        toldelay += delay;
> +    }
> +
> +    toldelay -= min + max;
> +    avgdelay = toldelay/(long long)(cons_num - 2);
> +    if (avgdelay > THRES_USEC_VALUE)
> +    {
> +        condlog(0, "%s: avgdelay is more than thresold", pp->dev);
> +        return 1;
> +    }
> +
> +	ratio = get_conversion_ratio(type);
> +	rc = (int)(THRES_USEC_VALUE - (avgdelay/(((long long)delay_interval) * ratio)));
> +
> +    return rc;
> +}
> diff --git a/libmultipath/prioritizers/delayedpath.h b/libmultipath/prioritizers/delayedpath.h
> new file mode 100644
> index 0000000..d8213e9
> --- /dev/null
> +++ b/libmultipath/prioritizers/delayedpath.h
> @@ -0,0 +1,17 @@
> +#ifndef _DELAYEDPATH_H
> +#define _DELAYEDPATH_H
> +
> +#define PRIO_DELAYED_PATH "delayedpath"

In order for the rest of the code to refer to this prioritizer, this
define should be in prio.h with the other prioritizer names, and as long
as delayedpath.c includes prio.h, there's no need to put it in
delayedpath.h.

> +
> +#define PRIO_NO_INFORMATION 5

The rest of the multipath code only cares if getprio returns a negative
number of not. It doesn't check what the specific negative number is.  I
realize the the alua prioritizer returns a set of error codes, but they
aren't used, or even usable in their present form. If we wanted to have
better error reporting, we should set up a universal set of error codes
in prio.h, and have all prioritizers use them, instead of having each
prioritizer define its own error codes. There's no reason why your
prioritizer needs to return this error code instead of -1.

> +
> +#define USEC_PER_SEC      1000000LL
> +#define USEC_PER_MSEC     1000LL
> +#define USEC_PER_USEC     1LL
> +
> +static inline long long timeval_to_us(const struct timespec *tv)
> +{
> +	return ((long long) tv->tv_sec * USEC_PER_SEC) + (tv->tv_nsec >> 10);
> +}

No other file besides delayedpath.c will likely be including this .h
file, so I don't see any purpose for these being defined here.  In fact,
I don't see why you can't just have a .c file without a .h file like the
majority of prioritizers.  I'm pretty sure that none of the prioritizers
really need their own .h file.

> +#endif
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 5939688..f1e126e 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -293,6 +293,10 @@ Generate a random priority between 1 and 10.
>  Generate the path priority based on the regular expression and the
>  priority provided as argument. Requires prio_args keyword.
>  .TP
> +.I delayedpath
> +Generate the path priority based on a time-delay algorithm.
> +Requires prio_args keyword.

Really it doesn't require prio_args if you want to use the default
values, and should probably say so.

> +.TP
>  .I datacore
>  .\" XXX
>  ???. Requires prio_args keyword.
> @@ -333,6 +337,21 @@ these values can be looked up through sysfs or by running \fImultipathd show pat
>  "%N:%R:%n:%r"\fR. For example: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*
>  .RE
>  .TP 12
> +.I delayed
> +Needs a value of the form
> +\fI"<delay_interval|cons_num>"\fR
> +.RS
> +.TP 8
> +.I delay_interval
> +The interval values of average IO-time-delay between two different neighbour ranks of path priority, used to partition different priority ranks.
> +Form: XXs, or XXXus, or XXXms. Unit: Second, or Microsecond, or Millisecond. Valid Values: Integer, s [1, 60], ms [1, 1000), us [1, 1000),
> +For example: 10s, or 100us, or 100ms. The default is: 10ms.
> +.TP
> +.I cons_num
> +The number of read IOs sent to the current path continuously, used to calculate the average IO-time-delay. Valid Values: Integer, [3, 1000].
> +For example: 30. The default is: 20.
> +.RE
> +.TP 12

Looking at the "weighted" prio_args definition just above your "delayed"
definition, the pipe character "|" is being used to say that any of a
set of options is allowed.  Your definition has it being a literal
character, but it's still inside the angle brackets that usually
delineate a variable.  perhaps "<delay_interval>|<io_num>" would be
easier to understand, or even "[delayed_interval]|[io_num]" if you can
omit these to use the defaults.

-Ben

>  .I alua
>  If \fIexclusive_pref_bit\fR is set, paths with the \fIpreferred path\fR bit
>  set will always be in their own path group.
> -- 
> 
> 
> 
> 
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
