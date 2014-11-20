From: Joe Thornber <thornber@redhat.com>
Subject: Re: dmcache RAID1 bug?
Date: Thu, 20 Nov 2014 14:10:04 +0000
Message-ID: <20141120141003.GB16741@debian>
References: <CAEZ+n-i7kOC3zZzrv5GHbmfuKJ3b1U6COG8DyDW8HjHk9wDf-Q@mail.gmail.com>
	<20141117144659.GA29929@redhat.com>
	<CAEZ+n-jJoCS0WqeeiETYf1jAwPJzy+fyEgr_-Qek+7NzS+uERQ@mail.gmail.com>
	<CAEZ+n-i3yP+qO6bVDs8O0CwkJKBNzVBMW6gOtd=dty9ALj_8eQ@mail.gmail.com>
	<CAEZ+n-ha0tFew+807rumUQsk-tqYVyxPUTrGoz0DvdCqLK50Og@mail.gmail.com>
	<20141120140426.GA16741@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141120140426.GA16741@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 20, 2014 at 02:04:26PM +0000, Joe Thornber wrote:
> On Wed, Nov 19, 2014 at 07:39:44PM -0200, Leonardo Santos wrote:
> > After run regression tests using 'git bisect', I identify that the error
> > was created after commit 8c081b52c6833a30a69ea3bdcef316eccc740c87
> > 
> > To reproduce this error just:
> > - create a raid1 HDDs for origin device;
> > - create a cache device with SSDs (could or not be raid)
> > - create a metadata device with SSDs (could or not be raid)
> > - create a cache device using prior devices
> > - kernel crashes.
> > 
> > @@ -1115,8 +1142,7 @@ static void check_for_quiesced_migrations(struct cache *cache,
> >  		return;
> >  
> >  	INIT_LIST_HEAD(&work);
> > -	if (pb->all_io_entry)
> > -		dm_deferred_entry_dec(pb->all_io_entry, &work);
> > +	dm_deferred_entry_dec(pb->all_io_entry, &work);
> >  
> >  	if (!list_empty(&work))
> >  		queue_quiesced_migrations(cache, &work);
> 
> This looks suspicious, I believe the all_io_entry is not set if the io
> covers a complete block.  Any chance you could test with this fragment
> backed out please?

Ignore me, there's another check for !pb->all_io_entry.
