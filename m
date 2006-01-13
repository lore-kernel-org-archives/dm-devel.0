From: Brian Wong <bwong@pillardata.com>
Subject: Re: STK / LSI Multipath Support
Date: Fri, 13 Jan 2006 11:05:44 -0800
Message-ID: <1137179144.3643.4.camel@ca-bwong3.trans.corp>
References: <111aefd0601121952r55594f0ahdb5ed4fa46ae145d@mail.gmail.com>
Reply-To: bwong@pillardata.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <111aefd0601121952r55594f0ahdb5ed4fa46ae145d@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


> 
> I am guessing this is because "prio_callout" is set to "/bin/true" so
> it defaults to the first path in the list.  Is there a prio_callout

silly question: is the path_grouping_policy set to "group_by_prio"?  

>  that works with lsi branded arrays?  I run SLES 9 and I see there are
> mpath_prio_{emc,tpc,alua}, but none (somewhat obviously) don't work. 

fwiw, I've used multipath with an active/passive box and prio_callout
set to "/sbin/mpath_prio_alua -d/tmp %d" successfully with paths
properly grouped active/passive.

cheers,

Brian
