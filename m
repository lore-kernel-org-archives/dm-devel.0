From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: User specific priorities on for iscsi paths doesn't
	seem to work
Date: Fri, 7 Aug 2009 16:43:04 -0400
Message-ID: <20090807204304.GA1181@redhat.com>
References: <4A7C8DB4.1090608@cleversafe.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A7C8DB4.1090608@cleversafe.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Akshay Lal <alal@cleversafe.com>
Cc: device-mapper development <dm-devel@redhat.com>, John Quigley <jquigley@cleversafe.com>
List-Id: dm-devel.ids

On Fri, Aug 07 2009 at  4:25pm -0400,
Akshay Lal <alal@cleversafe.com> wrote:

> I'm having a few issues with path priorities. It seems that the choice  
> of path to use during I/O is independent of the user defined priorities  
> for each path.
>
> I am setting the priorities by executing writing a script that is used  
> by prio_callout. This seems to work when I execute multipath -ll since  
> all the specified priorities show up correctly. (the  
> path_grouping_policy being used is  failover)

...

> Is there something I'm doing wrong? I would like to be able to define  
> the priorities per device, and ensure that data only traverses on the  
> lower priority path when
> a) a failure to the first path (path with a higher priority) occures
> b) no other path with a higher priority exists

Do things behave as you'd like if you change path_grouping_policy to
'group_by_prio'?

Mike
