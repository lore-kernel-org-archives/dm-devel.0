From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH] multipath-tools: intermittent IO error
 accounting to improve reliability
Date: Tue, 29 Aug 2017 11:18:35 +0800
Message-ID: <a82c0dc5-0aae-7c22-400d-9efc63f6bbaa@huawei.com>
References: <1503396479-12692-1-git-send-email-guanjunxiong@huawei.com>
	<1503926901.4546.26.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1503926901.4546.26.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: chengjike.cheng@huawei.com, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

Hello Martin,

Thanks for your comment again. Please find my reply inline.

An updated patch will be sent after applying your reasonable
suggestion.

On 2017/8/28 21:28, Martin Wilck wrote:
> Hello Guan,
> 
> sorry for replying late. Hannes has already commented on the general
> concept. I have a few more remarks on details here.
> 
> On Tue, 2017-08-22 at 18:07 +0800, Guan Junxiong wrote:
>> This patch adds a new method of path state checking based on
>> accounting
>> IO error. This is useful in many scenarios such as intermittent IO
>> error
>> an a path due to network congestion, or a shaky link.
>>
>> Three parameters are added for the admin: "path_io_err_sample_time",
>> "path_io_err_num_threshold" and "path_io_err_recovery_time".
>> If path_io_err_sample_time and path_io_err_recovery_time are set to a
>> value greater than 0, when a path fail event occurs due to an IO
>> error,
>> multipathd will enqueue this path into a queue of which each member
>> is
>> sent direct reading asynchronous io at a fixed sample rate of 100HZ. 
> 
> 1. I don't think it's prudent to start the flakiness check for every
> PATH_DOWN event. Rather, the test should only be started for paths that
> have failed repeatedly in a certain time frame, so that we have reason
> to assume they're flaky.
>

Sounds reasonable. And IMO, at least two new options of multipath.conf
should be introduced: time frame and threshold if we let the admin
to tune this. OTOH, if we don't want to bother the admin, we handle
the pre-flacky check automatically.  Maybe 60 second of time frame
and 2 PATH_UP->PATH_DOWNH events of thredshold is reasonable.
Which solution do you prefer?

> 2. How did you come up with the 100Hz sample rate value? It sounds
> quite high in the first place (that was my first thought when I read
> it), and OTOH those processes that run into intermittent IO errors are
> probably the ones that do I/O almost continuously, so maybe reading
> continuously for a limited time is the better idea?
> 

I am afraid of whether reading for a limited time will affect the usable
bandwidth of the true up-layer transaction. If not, reading continuously
is the nearest to the real case.
How about 10Hz sample rate and 10ms continuous reading?  In other words,
every 100ms interval, we read continuously for 10ms.


> 3. I would suggest setting the dm status of paths undergoing the
> flakiness test to "failed" immediately. That way the IO caused by the
> test will not interfere with the regular IO on the path. 
> 
Great.

> 4. I can see that you chose aio to avoid having to create a separate
> thread for each path being checked. But I'm wondering whether using aio
> for this is a good choice in general. My concern with aio is that to my
> knowledge there's no good low-level cancellation mechanism. When you
> io_cancel() one of your requests, you can be sure not to get notified
> of its completion any more, but that doesn't mean that it wouldn't
> continue to lurk down in the block layer. But I may be overlooking
> essential stuff here.
> 
>> Thethr
>> IO accounting process for a path will last for
>> path_io_err_sample_time.
>> If the number of IO error on a particular path is greater than the
>> path_io_err_num_threshold, then the path will not reinstate for
> 
> It would be more user-friendly to allow the user to specify the error
> rate threshold as a percentage
Error rate threshold as a percentage is not enough to distinguish small
error rate. How about a permillage rate (1/1000)?


>> +struct io_err_stat_path *find_err_path_by_dev(vector pathvec, char
>> *dev)
> 
> You are re-implementing generic functionality here (find_path_by_dev),
> why?
> 

Yes, because the structure is different: struct  io_err_stat_path and
struct path.


>> +
>> +static void free_io_err_stat_path(struct io_err_stat_path *p)
>> +{
>> +	if (p)
>> +		FREE(p);
>> +}
> 
> Nitpick: This check isn't necessary.
> 

Apply.


>> +static int check_async_io(struct vectors *vecs, struct
>> io_err_stat_path *pp,
>> +			int rc)
>> +{
>> +	struct timespec currtime, difftime;
>> +	struct path *path;
>> +
>> +	switch (rc) {
>> +	case PATH_UNCHECKED:
>> +		break;
>> +	case PATH_UP:
>> +		break;
>> +	case PATH_DOWN:
>> +		pp->io_err_nr++;
>> +		break;
>> +	case PATH_TIMEOUT:
>> +		pp->io_err_nr++;
>> +		break;
>> +	case PATH_PENDING:
>> +		break;
>> +	default:
>> +		break;
>> +	}
> 
> Nitpick: This case statement could be grouped more nicely.
> 

Nice suggestion.

>> +
>> +	if (clock_gettime(CLOCK_MONOTONIC, &currtime) != 0)
>> +		return 1;
>> +	timespecsub(&currtime, &pp->start_time, &difftime);
>> +	if (difftime.tv_sec < pp->total_time)
>> +		return 0;
>> +
>> +	io_err_stat_log(3, "check end for %s", pp->devname);
> 
> As this is called for every IO, please use a "higher" prio value (I
> suggest 5).
> 
This is not called for every IO but for the end of wholie checking process
because :
 +	if (difftime.tv_sec < pp->total_time)
 +		return 0;

>> +
>> +	pthread_cleanup_push(cleanup_lock, &vecs->lock);
>> +	lock(&vecs->lock);
>> +	pthread_testcancel();
>> +	path = find_path_by_dev(vecs->pathvec, pp->devname);
>> +
>> +	if (!path) {
>> +		io_err_stat_log(3, "path %s not found'", pp-
>>> devname);
>> +	} else if (pp->io_err_nr <= pp->err_num_threshold) {
>> +		io_err_stat_log(3, "%s: (%d/%d) not hit threshold",
>> +				pp->devname, pp->io_err_nr, pp-
>>> io_nr);
> 
> The loglevel here should also be "higher".
> 
I will set 4 log level in the next patch.

>> +	} else if (path->mpp && path->mpp->nr_active > 1) {
>> +		dm_fail_path(path->mpp->alias, path->dev_t);
>> +		update_queue_mode_del_path(path->mpp);
>> +		io_err_stat_log(2, "%s: proacively fail dm path %s",
> 
> -> proactively
> 
Good, thanks.


>> +static int send_async_io(struct io_err_stat_path *pp, int
>> timeout_secs)
>> +{
>> +	struct timespec	timeout = { .tv_nsec = 5 };
> 
> You might as well set this to 0, as you don't seem to intend to "wait"
> for 5 ns anyway, you just want to test for completion.
>
Great, thanks.

>> +	struct timespec curr_time, difftime;
>> +	struct io_event event;
>> +	int		rc = PATH_UNCHECKED;
>> +	long		r;
>> +
>> +	struct dio_ctx *ct = pp->pd_ctx;
>> +
>> +	if (!ct)
>> +		return rc;
>> +
>> +	if (ct->io_starttime.tv_nsec == 0 &&
>> +			ct->io_starttime.tv_sec == 0) {
>> +		struct iocb *ios[1] = { &ct->io };
>> +
>> +		memset(&ct->io, 0, sizeof(struct iocb));
>> +		io_prep_pread(&ct->io, pp->fd, ct->ptr, ct->blksize, 
>> 0);
>> +		if (io_submit(ct->ioctx, 1, ios) != 1) {
>> +			io_err_stat_log(3, "%s: io_submit error %i",
>> +					pp->devname, errno);
>> +			return rc;
>> +		}
>> +
>> +		if (clock_gettime(CLOCK_MONOTONIC, &ct-
>>> io_starttime) != 0) {
>> +			ct->io_starttime.tv_sec = 0;
>> +			ct->io_starttime.tv_nsec = 0;
>> +		}
> 
> IMO this is wrong. If clock_gettime() fails, you're in serious trouble
> and just resetting the time won't save you. This looks like a fatal
> error condition to me, you should abort the test or whatever.
> 
Great. I will change this.


>> +
>> +		if (pp->start_time.tv_sec == 0 && pp-
>>> start_time.tv_nsec == 0 &&
>> +			clock_gettime(CLOCK_MONOTONIC, &pp-
>>> start_time)) {
> 
> See above.
> 
>> +			pp->start_time.tv_sec = 0;
>> +			pp->start_time.tv_nsec = 0;
>> +			return rc;
>> +		}
>> +		pp->io_nr++;
>> +	}
>> +
>> +	errno = 0;
>> +	r = io_getevents(ct->ioctx, 1L, 1L, &event, &timeout);
> 
> The way you implemented this, you do a lot of event polling. Could you
> perhaps use a comment aio_context for all paths, and poll only once?
> 
> Or maybe, as this is aio, you could just io_submit with 100 Hz (or
> whatever) frequency, wait a bit to give the the latest submissions time
> to complete, and then collect all events in a single io_getevents()
> call.
> 
> You may even be able to combine both ideas to reduce polling even more.
> 

Thanks. I will try to optimize this given your great suggestion.

>> +	if (r < 0) {
>> +		io_err_stat_log(3, "%s: async io events returned %d
>> (errno=%s)",
>> +				pp->devname, r, strerror(errno));
>> +		ct->io_starttime.tv_sec = 0;
>> +		ct->io_starttime.tv_nsec = 0;
>> +		rc = PATH_UNCHECKED;
>> +	} else if (r < 1L) {
>> +		if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0)
>> +			curr_time.tv_sec = 0;
>> +		timespecsub(&curr_time, &ct->io_starttime,
>> &difftime);
>> +
>> +		if (difftime.tv_sec > timeout_secs) {
>> +			struct iocb *ios[1] = { &ct->io };
>> +
>> +			io_err_stat_log(3, "%s: abort check on
>> timeout",
>> +					pp->devname);
>> +			r = io_cancel(ct->ioctx, ios[0], &event);
>> +			if (r)
>> +				io_err_stat_log(3, "%s: io_cancel
>> error %i",
>> +						pp->devname, errno);
> 
> This is a serious error. I don't think it can come to pass easily, but
> if does, you're in trouble. Perhaps increase the start time here so
> that you don't repeat this code path with every invocation of
> check_async_io()?
> 
I will inspect this. Thanks.


>> +
>> +	mlockall(MCL_CURRENT | MCL_FUTURE);
>> +	while (1) {
>> +		service_paths();
>> +		usleep(10000); //TODO FIXME  impact perf
> 
> Do you intend to fix this in a future submission?
> 
Yes. I will change this into 10Hz and using reading continuously for
10 ms.


> Regards,
> Martin
Best Wishes
Guan Junxiong
