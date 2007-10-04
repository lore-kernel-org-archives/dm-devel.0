From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Rename prio callout program mpath_prio_netapp
	to mpath_prio_ontap
Date: Thu, 4 Oct 2007 17:51:49 +0100
Message-ID: <20071004165149.GT18444@agk.fab.redhat.com>
References: <200710041455.20037.rsarraf@netapp.com>
	<20071004110157.GR18444@agk.fab.redhat.com>
	<200710042205.23145.rsarraf@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200710042205.23145.rsarraf@netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ritesh Raj Sarraf <rsarraf@netapp.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Oct 04, 2007 at 10:05:16PM +0530, Ritesh Raj Sarraf wrote:
> For RHEL5/4 series, is it okay to have "mpath_prio_netapp" as a link pointing 
> to "mpath_prio_ontap" ?

Yes - we can add things easily; just not remove existing files or make
existing configuration parameters stop working unless there's a
compelling reason (like security or if it's the only way to fix a
serious design flaw).
 
> As for RHEL6 and ahead, we could just remove "mpath_prio_netapp".

Yes.

Alasdair
-- 
agk@redhat.com
