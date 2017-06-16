From: Yang Feng <philip.yang@huawei.com>
Subject: Re: [PATCH v5 1/1] multipath-tools: Prioritizer based on
 a latency algorithm
Date: Fri, 16 Jun 2017 17:12:31 +0800
Message-ID: <9e381a2a-eac0-4ce2-7ab1-085656d2f858@huawei.com>
References: <1497002306-26880-1-git-send-email-philip.yang@huawei.com>
	<1497002306-26880-2-git-send-email-philip.yang@huawei.com>
	<1497473221.4654.74.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1497473221.4654.74.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, hare@suse.de, christophe.varoqui@opensvc.com, bmarzins@redhat.com, xose.vazquez@gmail.com
Cc: zouming.zouming@huawei.com, guanjunxiong@huawei.com, shenhong09@huawei.com, dm-devel@redhat.com, hege09@huawei.com, qiuxin@huawei.com
List-Id: dm-devel.ids

Hi Martin,

Thanks for your reviews.
Please find my replys.
And the patch v6 will be sent later.

Regards,
Yang

---
> 
>> +#define MAX_LATENCY_INTERVAL    10            /*unit: s*/
>> +#define MIN_LATENCY_INTERVAL    1             /*unit: us, or ms, or s*/
> 
> Why not use the same unit or both values?
> 
It's easy to check the valid range of the "latency_interval" value.
For unit: us, or ms, or s, the min digital value is the same, is 1.
And for all unit, the max conversion value is the same, is 10 seconds.

>> +static inline long long timeval_to_us(const struct timespec *tv)
>> +{
>> +	return ((long long) tv->tv_sec * USEC_PER_SEC) + (tv-
>>> tv_nsec >> 10);
> 
> Please calculate correctly, divide by 1000.
> 
Thanks, it will be fixed.

>> +int check_args_valid(int io_num, long long latency_interval, int
>> type)
>> +{
>> +    if ((io_num < MIN_IO_NUM) || (io_num > MAX_IO_NUM))
>> +    {
>> +        condlog(0, "args io_num is more than the valid values
>> range");
>> +        return 0;
>> +    }
> 
> Please write "outside the valid range" rather than "more than the valid
> values range".
> 
Thanks, it will be fixed.

> In general, when you use condlog(), please prefix all messages with a
> string that clearly identifies the path_latency prioritizer, e.g.
> PRIO_PATH_LATENCY.
> I know we're not currently doing that consistently in multipath-tools,
> but that shouldn't be a reason for not doing when adding new code.
> 
Good, thanks, it will be fixed.

>> +
>> +    /* check value is set by using logarithmic scale, and base
>> number is 10 */
>> +    if ((latency_interval % BASE_NUMBER) != 0)
>> +    {
>> +        condlog(0, "args latency_interval is not set by using
>> logarithmic scale , where base number is 10");
>> +        return 0;
>> +    }
> 
> This is not what I meant with "logarithmic scale". See below.
> 
>> +
>> +    /* s:[1, 10], ms:[1, 10000], us:[1, 10000000] */
>> +    if ((latency_interval < MIN_LATENCY_INTERVAL)
>> +        || (latency_interval > (MAX_LATENCY_INTERVAL * USEC_PER_SEC
>> / conversion_ratio[type])))
>> +    {
>> +        condlog(0, "args latency_interval is more than the valid
>> values range");
>> +        return 0;
>> +    }
> 
> Again, please use "outside".
> 
Thanks, it will be fixed.

>> +/* In multipath.conf, args form: io_num|latency_interval. For
>> example,
>> +*  args is "20|10ms", this function can get 20, 10.
>> +*/
>> +static int get_interval_and_ionum(char *args,
>> +                                        int *ionum,
>> +                                        long long *interval)
>> +{
>> +    char source[MAX_CHAR_SIZE];
>> +    char vertica = '|';
>> +    char *endstrbefore = NULL;
>> +    char *endstrafter = NULL;
>> +    int type;
>> +    unsigned int size = strlen(args);
>> +    long long ratio;
>> +
>> +    if ((args == NULL) || (ionum == NULL) || (interval == NULL))
>> +    {
>> +        condlog(0, "args string is NULL");
>> +        return 0;
>> +    }
>> +
>> +    if ((size < 1) || (size > MAX_CHAR_SIZE-1))
>> +    {
>> +        condlog(0, "args string's size is too long");
>> +        return 0;
>> +    }
> 
> "too long" is not correct for the first (more likely) error condition.
> 
>> +
>> +    memcpy(source, args, size+1);
>> +
>> +    if (!isdigit(source[0]))
>> +    {
>> +        condlog(0, "args io_num string's first char is not digit");
>> +        return 0;
>> +    }
> 
> It would be ok to catch all these errors with a single line of code
> such as "path_latency: invalid prio_args format: %s".
> 
OK, it will be fixed.

>> +
>> +    *ionum = (int)strtoul(source, &endstrbefore, 10);
>> +    if (endstrbefore[0] != vertica)
>> +    {
>> +        condlog(0, "segmentation char is invalid");
>> +        return 0;
>> +    }
>> +
>> +    if (!isdigit(endstrbefore[1]))
>> +    {
>> +        condlog(0, "args latency_interval string's first char is not
>> digit");
>> +        return 0;
>> +    }
>> +
>> +    *interval = (long long)strtol(&endstrbefore[1], &endstrafter,
>> 10);
>> +    type = get_interval_type(endstrafter);
>> +    if (type == INTERVAL_INVALID)
>> +    {
>> +        condlog(0, "args latency_interval type is invalid");
>> +        return 0;
>> +    }
>> +
>> +    if (check_args_valid(*ionum, *interval, type) == 0)
>> +    {
>> +        return 0;
>> +    }
>> +
>> +	ratio = get_conversion_ratio(type);
>> +    *interval *= (long long)ratio;
>> +
>> +    return 1;
>> +}
>> +
>> +long long calc_standard_deviation(long long *path_latency, int size,
>> long long avglatency)
>> +{
>> +    int index;
>> +    long long total = 0;
>> +
>> +    for (index = 0; index < size; index++)
>> +    {
>> +        total += (path_latency[index] - avglatency) *
>> (path_latency[index] - avglatency);
>> +    }
>> +
>> +    total /= (size-1);
>> +
>> +    return (long long)sqrt((double)total);
>> +}
>> +
>> +int getprio (struct path *pp, char *args, unsigned int timeout)
>> +{
>> +    int rc, temp;
>> +    int index = 0;
>> +    int io_num;
>> +    long long latency_interval;
>> +    long long avglatency;
>> +    long long standard_deviation;
>> +    long long toldelay = 0;
>> +    long long before, after;
>> +    struct timespec tv;
>> +
>> +	if (pp->fd < 0)
>> +		return -1;
>> +
>> +    if (get_interval_and_ionum(args, &io_num, &latency_interval) ==
>> 0)
>> +    {
>> +        condlog(0, "%s: get path_latency args fail", pp->dev);
>> +        return DEFAULT_PRIORITY;
>> +    }
> 
> Could you just assume reasonable defaults for the path latency
> algorithm rather than returning a constant?
> 
En, I think returning a DEFAULT_PRIORITY "0" is no problem.
If return a assumed value, then the user can be confused, because
the defaults is not set.

>> +
>> +    memset(path_latency, 0, sizeof(path_latency));
>> +
>> +    temp = io_num;
>> +    while (temp-- > 0)
>> +    {
>> +        (void)clock_gettime(CLOCK_MONOTONIC, &tv);
>> +        before = timeval_to_us(&tv);
>> +
>> +        if (do_readsector0(pp->fd, timeout) == 2)
>> +        {
>> +            condlog(0, "%s: path down", pp->dev);
>> +            return -1;
>> +        }
>> +
>> +        (void)clock_gettime(CLOCK_MONOTONIC, &tv);
>> +        after = timeval_to_us(&tv);
>> +
>> +        path_latency[index] = after - before;
>> +        toldelay += path_latency[index++];
>> +    }
>> +
>> +    avglatency = toldelay/(long long)io_num;
>> +    condlog(4, "%s: average latency is (%lld)", pp->dev,
>> avglatency);
>> +
>> +    if (avglatency > THRES_USEC_VALUE)
>> +    {
>> +        condlog(0, "%s: average latency (%lld) is more than
>> thresold", pp->dev, avglatency);
>> +        return DEFAULT_PRIORITY;
>> +    }
> 
> Why don't you put simply put this in the highest latency bin? See
> below.
> 
Thanks, it will be fixed.

>> +
>> +    /* warn the user if the latency_interval set is smaller than (2
>> * standard deviation), or equal */
>> +    standard_deviation = calc_standard_deviation(path_latency,
>> index, avglatency);
>> +    if (latency_interval <= (2 * standard_deviation))
>> +        condlog(3, "%s: args latency_interval set is smaller than 2
>> * standard deviation (%lld us), or equal",
>> +            pp->dev, standard_deviation);
>> +
>> +	rc = (int)(THRES_USEC_VALUE - (avglatency/(long
>> long)latency_interval));
>> +    return rc;
>> +}
> 
> Hm, I think you misunderstood my "logarithmic scale" idea.
> By dividing the average by the interval size, you get ordinary linear
> scaling again. That doesn't help the problem.
> 
> Here is a sample program illustrating what I meant. It uses math.h
> functions, but that shouldn't be a problem; we're running in user
> space. The chosen interval size, corresponding to a factor of 1.995, is
> probably a good choice for many scenarios. Your could represent the
> range between 1us and 10s with 34 prio values, and still be able to
> differentiate paths with, say, 1.5 and 3 us latency.
> 
> If you use this, you should also use double type for calculating the
> average and stddev, and you must be careful to calculate the standard
> deviation for the logarithms, as interval size is not constant any more
> (only on logarithmic scale).
> 
> #include <stdio.h>
> #include <math.h>
> 
> /*
>  * For a given positive value x, return a "prio" between 0 and n
>  * using logarithmically scaled intervals between minval and maxval.
>  */
> 
> int log_prio(double x,
> 	     unsigned long minval, unsigned long maxval, unsigned n)
> {
> 	double lx, lmin, lmax;
> 	if (x <= minval)
> 		return n;
> 	if (x >= maxval)
> 		return 0;
> 	lx = log10(x);
> 	lmin = log10(minval);
> 	lmax = log10(maxval);
> 	return n - (n - 1) * (lx - lmin) / (lmax - lmin);
> }
> 
> int main(void)
> {
> 	int minval = 1;
> 	int maxval = 1000;
> 	int n = 11;
> 	double x;
> 	for (x = minval/2.; x < maxval*2.; x *= sqrt(2.))
> 		printf("%f: %d\n", x, log_prio(x, minval, maxval, n));
> 	return 0;
> }
> 
OK, the argument "latency_interval" will be delete, instead, the argument
"base_num" will be added for logarithmic scale.
And min value will be set 1 us, max value will be set 10000000 us (or 10 s).

> Regards,
> Martin
> 
