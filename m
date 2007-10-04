From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Rename prio callout program mpath_prio_netapp
	to mpath_prio_ontap
Date: Thu, 4 Oct 2007 12:01:57 +0100
Message-ID: <20071004110157.GR18444@agk.fab.redhat.com>
References: <200710041455.20037.rsarraf@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200710041455.20037.rsarraf@netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: rsarraf@netapp.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Oct 04, 2007 at 02:55:19PM +0530, Ritesh Raj Sarraf wrote:
> Attached are 2 patches to rename the callout program from mpath_prio_netapp to 
> mpath_prio_ontap.

We're unable to take such a patch into RHEL directly because it is removing a
program that was there before and that breaks backwards compatibility, but
how about maintaining a symlink from the old location?

Alasdair
-- 
agk@redhat.com
