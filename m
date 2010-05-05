From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [dm-devel] [PATCH 1/2] dm: Add feature flags to dm-mpath
Date: Wed, 5 May 2010 16:04:57 -0700
Message-ID: <20100505230457.GA7515@linux.vnet.ibm.com>
References: <1272945691-31649-1-git-send-email-andmike@linux.vnet.ibm.com>
 <1272945691-31649-2-git-send-email-andmike@linux.vnet.ibm.com>
 <20100505200128.GA19763@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100505200128.GA19763@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

Mike Snitzer <snitzer@redhat.com> wrote:
> On Tue, May 04 2010 at 12:01am -0400,
> Mike Anderson <andmike@linux.vnet.ibm.com> wrote:
> 
> > +++ b/drivers/md/dm-mpath.c
> > @@ -82,6 +82,7 @@ struct multipath {
> >  	unsigned saved_queue_if_no_path;/* Saved state during suspension */
> >  	unsigned pg_init_retries;	/* Number of times to retry pg_init */
> >  	unsigned pg_init_count;		/* Number of times pg_init called */
> > +	unsigned long features;
> 
> Why not use uint64_t?

I was just following dm.c mapped_device flags as an example, but could be
changed.
> 
> >  	struct work_struct process_queued_ios;
> >  	struct list_head queued_ios;
> > @@ -118,6 +119,15 @@ static void trigger_event(struct work_struct *work);
> >  static void activate_path(struct work_struct *work);
> >  static void deactivate_path(struct work_struct *work);
> >  
> > +static int multipath_test_feature(struct multipath *m, unsigned feature)
> > +{
> > +	return test_bit(feature, &m->features);
> > +}
> > +
> > +static void multipath_set_feature(struct multipath *m, unsigned feature)
> > +{
> > +	set_bit(feature, &m->features);
> > +}
> 
> You're using 'unsigned long' for features yet these wrapper functions
> take 'unsigned'.  unsigned allows you to use {test,set}_bit but in the
> end we have fewer flags to work with...
> 
> Granted you're introducing the very first flag but... ;)
> 

As I indicated above I used dm.c bit setting as an example. The feature
bit nr plus the {test,set}_bit appeared like a good start but as you said
I was just introducing the first flag. I guess it depends on how many
features we think we might need. 

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
