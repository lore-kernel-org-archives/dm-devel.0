From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: dm: impose configurable deadline for dm_request_fn's
 merge heuristic
Date: Mon, 2 Mar 2015 19:31:44 +0300
Message-ID: <20150302163143.GA27120@mwanda>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Mike Snitzer,

The patch 6ee47d96b97d: "dm: impose configurable deadline for
dm_request_fn's merge heuristic" from Feb 26, 2015, leads to the
following static checker warning:

	drivers/md/dm.c:1968 dm_attr_rq_based_queue_deadline_store()
	warn: impossible condition '(deadline > ((~0 >> 1))) => (s32min-s32max > s32max)'

drivers/md/dm.c
  1959  ssize_t dm_attr_rq_based_queue_deadline_store(struct mapped_device *md,
  1960                                                const char *buf, size_t count)
  1961  {
  1962          int err, deadline;
  1963  
  1964          if (!dm_request_based(md))
  1965                  return count;
  1966  
  1967          err = kstrtoint(buf, 10, &deadline);
  1968          if (err || deadline > INT_MAX)
                           ^^^^^^^^^^^^^^^^^^
Impossible condition.  But it might not hurt to test for negative
deadlines?

  1969                  return -EINVAL;
  1970  
  1971          if (!deadline)
  1972                  deadline = DEF_QUEUE_DEADLINE;
  1973          else if (deadline > MAX_QUEUE_DEADLINE)
  1974                  deadline = MAX_QUEUE_DEADLINE;
  1975  
  1976          atomic_set(&md->rq_based_queue_deadline, deadline);
  1977  
  1978          return count;
  1979  }

regards,
dan carpenter
