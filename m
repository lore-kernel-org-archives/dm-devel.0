From: Yang Feng <philip.yang@huawei.com>
Subject: Re: [PATCH] multipath-tools:Prioritizer based on a
 time-delay algorithm
Date: Tue, 16 May 2017 22:53:17 +0800
Message-ID: <73f14943-de99-48ec-5406-7eb2f0014ae0@huawei.com>
References: <1494215904-7564-1-git-send-email-philip.yang@huawei.com>
	<1494501243.6093.16.camel@suse.com>
	<aec35be2-fa7f-1fc8-9cd8-a52647cddc13@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <aec35be2-fa7f-1fc8-9cd8-a52647cddc13@huawei.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: zouming.zouming@huawei.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, guanjunxiong@huawei.com, shenhong09@huawei.com, dm-devel@redhat.com, hege09@huawei.com
List-Id: dm-devel.ids

Hello Martin,

How about this patch?
Thanks a lot,
Best regards.


On 2017/5/15 18:44, Yang Feng wrote:
> Hello Martin,
> 
> Thank you very much for your remarks. I am sorry for late reply, Please find my answer and the updated patch.
> 
>> Hello Yang,
>>
>> thank you for your work. Please find my remarks below.
>>
>> On Mon, 2017-05-08 at 11:58 +0800, Yang Feng wrote:
>>> Prioritizer for device mapper multipath, where the corresponding
>>> priority
>>> values of specific paths are provided by a time-delay algorithm. And
>>> the
>>> time-delay algorithm is dependent on the following
>>> arguments(delay_interval,
>>> cons_num).
>>> The principle of the algorithm is illustrated as follows:
>>> 1. By sending a certain number "cons_num" of read IOs to the current
>>> path
>>>    continuously, the IOs' average delay can be calculated.
>>> 2. According to the average delay of each path and the weight value
>>>    "delay_interval", the priority "rc" of each path can be provided.
>>>
>>>      delay_interval  delay_interval  delay_interval       delay_inter
>>
>> How does this algorithm behave under load? Can we be sure that
>> priorities don't start to fluctuate wildly because busy paths will
>> usually have longer latencies than idle ones?
> I have a lot of test under load. When the appropriate value of argument "delay_interval" is set,
> this algorithm behave well and can separate the paths who's average delay is more than others.
> When add a new path or the path's state change from down to up, getprio() of the prioritizer is triggered, and
> the current path is not under IOs.
> 
>>>  libmultipath/Makefile                   |   2 +-
>>>  libmultipath/checkers/Makefile          |   7 +-
>>>  libmultipath/checkers/emc_clariion.c    |   2 +-
>>>  libmultipath/checkers/libsg.c           |  94 ------------
>>>  libmultipath/checkers/libsg.h           |   9 --
>>>  libmultipath/checkers/readsector0.c     |   2 +-
>>>  libmultipath/libsg.c                    |  94 ++++++++++++
>>>  libmultipath/libsg.h                    |   9 ++
>>>  libmultipath/prioritizers/Makefile      |   6 +-
>>>  libmultipath/prioritizers/delayedpath.c | 246 
>>
>> Why do you have to move libsg for this? It's already used by various
>> checkers, why can't your checker do the same? If you really need to do
>> it, you should at least separate that part of the patch from the added
>> code.
> OK, this time, libsg will not be moved.
> 
>>> +
>>> +#define CHAR_SEC                "SEC"
>>> +#define CHAR_MSEC               "MSEC"
>>> +#define CHAR_USEC               "USEC"
>>
>> I suggest to use "s", "ms", and "us" here instead.
> OK, as the following patch.
> 
>> If you create an array of "const char*" instead like you did for
>> conversion_ratio below, you could implement get_interval_type() more
>> elegantly using a loop over that array.
> OK, as the following patch.
> 
>>> +static int get_interval_type(char *source, char *type)
>>> +{  
>>> +    /*is USEC*/
>>> +    if ((strstr(source, CHAR_USEC) != NULL)
>>> +        && (strstr(source, CHAR_USEC)[4] == '_'))
>>
>> Please avoid these double strstr() invocation. The compiler may
>> optimize it away, but it just looks strange. The following would 
>> look better to me, and I find it actually more readable:
>>
>>         if (((p = strstr(source, CHAR_USEC)) != NULL) && p[4] == '_')
> OK, as the following patch.
> 
>>> +static int get_string_from_under(char *args,
>>> +                                        char *beforestring,
>>> +                                        char *afterstring,
>>> +                                        int *type)
>>
>> Maybe you could figure out a more descriptive name for this function?
>>
>> A comment in the code showing how the string to be parsed typically
>> looks like would be helpful for the reader.
> OK, as the following patch.
> 
>>> +    token = strtok_r(source, under, &saveptr);
>>> +    token = strtok(token, char_type);
>>
>> I'm pretty sure this is is not what you intended to write. If char_type
>> is "usec", this would split the string at the possible delimiters 'u',
>> 's', 'e', and 'c' (the 2nd argument of strtok(3) is not a sequence, but
>> a 'set' of bytes). It might accidentally work with the input strings
>> you are using (in particular because you only look at the first token),
>> but nevertheless it's wrong.
> OK, as the following patch.
> 
>>> +    if ((token == NULL) || (saveptr == NULL))
>>> +        return 0;
>>> +
>>> +    tmp = token;
>>> +    while (*tmp != '\0')
>>> +        if (!isdigit(*tmp++))
>>> +            return 0;
>>> +
>>> +    tmp = saveptr;
>>> +    while (*tmp != '\0')
>>> +        if (!isdigit(*tmp++))
>>> +            return 0;
>>> +
>>> +    strncpy(beforestring, token, strlen(token) + 1);
>>> +    strncpy(afterstring, saveptr, strlen(saveptr) + 1);
>>> +    return 1;
>>> +}
>>
>> I don't think it's safe to use saveptr the way you do it. The strtok_r
>> man page says this parameter is for "internal use". While it makes
>> sense to assume that it points to the next token, I'm not sure if
>> that's guaranteed. You would be safe by calling 
>>
>>     somevar = strtok_r(NULL, under, &saveptr)
>>
>> and use "somevar".
> OK, as the following patch.
> 
>>
>> In general, this whole parsing code is odd. IIUC this parses input
>> looking like ([0-9]+)(SEC|MSEC|USEC)_([0-9]+) and sets beforestring,
>> type, and afterstring to the regex matches \1, \2, and \3,
>> respectively.
>>
>> Why don't you start parsing from the beginning of the input, e.g. with
>> strtoul(), and look at the rest later?
> OK, as the following patch.
> 
>>> +
>>> +int checkargvalid(int delay_interval, int cons_num, int type)
>>> +{
>>> +    if (type == INTERVAL_SEC)
>>> +    {
>>> +        if ((delay_interval < 1) || (delay_interval > 60))
>>> +            return 0;
>>> +    }
>>> +    else if (type != INTERVAL_INVALID)
>>> +    {
>>> +        if ((delay_interval < 1) || (delay_interval >= 1000))
>>> +            return 0;
>>> +    }
>>
>> You could be more forgiving here. 15000MSEC could be a legal value.
> Because this value is more than 1 second, you can use the unit second.
> 
>>
>>> +    
>>> +    if ((cons_num < 3) || (cons_num > 1000))
>>> +        return 0;
>>> +
>>> +    return 1;
>>> +}
>>> +
>>> +int get_delay_pref_arg(char *args, int *delay_interval, int
>>> *cons_num, int *type)
>>> +{
>>> +    char delayintervalstr[MAX_CHAR_SIZE];
>>> +    char consnumstr[MAX_CHAR_SIZE];
>>> +
>>> +    if (get_string_from_under(args, delayintervalstr, consnumstr,
>>> type) == 0)
>>> +        return 0;
>>
>> It might be good to write the parser so that the consnum part can be
>> left out by the user, and assume a reasonable default in that case.
> OK, as the following patch.
> 
>>> +    while (temp-- > 0)
>>> +    {
>>> +        (void)gettimeofday(&tv, NULL);
>>> +        before = timeval_to_us(&tv);		
>>> +
>>> +        if (do_readsector0(pp->fd, timeout) == 2)
>>> +        {
>>> +            condlog(0, "%s: path down", pp->dev);
>>> +            return 1;
>>> +        }
>>> +        
>>> +        (void)gettimeofday(&tv, NULL);
>>
>> It's better to use clock_gettime(CLOCK_MONOTONIC, ...) here. Then you
>> can throw away the delay < 0 check below.
> OK, as the following patch.
> 
>>> +    toldelay -= min + max;
>>> +    avgdelay = toldelay/(long long)(cons_num - 2);
>>> +    if (avgdelay > THRES_USEC_VALUE) 
>>> +    {           
>>> +        condlog(0, "%s: avgdelay is more than thresold", pp->dev);
>>> +        return 1;
>>> +    }
>>> +    
>>> +	ratio = get_conversion_ratio(type);
>>> +	rc = (int)(THRES_USEC_VALUE - (avgdelay/(((long
>>> long)delay_interval) * ratio)));
>>> +
>>> +    return rc;
>>> +}
>>
>> Is it reasonable to do these interval calculations synchronously in
>> getprio()? cons_num is limited to 1000, so this routine could issue
>> 1000 reads on the device before returning. In particular if the device
>> is under IO load and the delay is high, execution if this routine could
>> be really slow.
>>
>> It would make more sense to me to have a separate thread that
>> calculates some sort of "running average" for the delay of the
>> different paths, and have getprio() just fetch the current value of
>> that variable.
>>
>> Regards
>> Martin
>>
> When add a new path or the path's state change from down to up, getprio() of the prioritizer is triggered, and
> the current path is not under IOs.
> Usually, the 1000 reads will be finish fastly.
> And have getprio() need to get the up-to-date average delay of the current path, these interval calculations synchronously
> is essential because of unreasonable asynchronously process's executing time D-value, particulayly when add a new path or
> the path's state change down to up.
> 
> Please find the up-to-date patch below:
> 
> ---
>>From 1a9426dfbad00b5dbefc7020603e40e8896e4869 Mon Sep 17 00:00:00 2001
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
> +
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
> +
> +#define PRIO_NO_INFORMATION 5
> +
> +#define USEC_PER_SEC      1000000LL
> +#define USEC_PER_MSEC     1000LL
> +#define USEC_PER_USEC     1LL
> +
> +static inline long long timeval_to_us(const struct timespec *tv)
> +{
> +	return ((long long) tv->tv_sec * USEC_PER_SEC) + (tv->tv_nsec >> 10);
> +}
> +
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
>  .I alua
>  If \fIexclusive_pref_bit\fR is set, paths with the \fIpreferred path\fR bit
>  set will always be in their own path group.
> 
