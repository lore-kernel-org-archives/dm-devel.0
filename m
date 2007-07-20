From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Question about dmevents
Date: Fri, 20 Jul 2007 18:14:04 +0100
Message-ID: <20070720171404.GC459@agk.fab.redhat.com>
References: <20070720162626.GA459@agk.fab.redhat.com>
	<D44F48C7D79D2943A073C8FA0F49A3CC0122633A@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <D44F48C7D79D2943A073C8FA0F49A3CC0122633A@orsmsx418.amr.corp.intel.com>
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

On Fri, Jul 20, 2007 at 09:57:28AM -0700, Wood, Brian J wrote:
> Hi Alasdair, I also read in the definition of DM_DEV_CREATE that the
> uuid is optional. Since that is the case shouldn't the failure for not
> having a uuid in "_alloc_thread_status()" be taken out?
 
I don't know this code, but in general userspace code should use uuid if it is
present.  If it isn't, it should fall back to using the name.  Whether that
leads to sensible behaviour in this particular case, I don't know.  If it
doesn't then it should be documented that uuid is a requirement.

Alasdair
-- 
agk@redhat.com
