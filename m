From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 28/57] libmultipath: use a shared lock
	to	co-operate with udev
Date: Tue, 3 May 2016 15:38:49 +0100
Message-ID: <20160503143849.GD18491@agk-dp.fab.redhat.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-29-git-send-email-hare@suse.de>
	<20160502162617.GS26117@octiron.msp.redhat.com>
	<57283DAD.9040009@suse.de>
	<20160503142732.GB26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160503142732.GB26117@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Tue, May 03, 2016 at 09:27:32AM -0500, Benjamin Marzinski wrote:
> I don't see why this same issue can't happen for anyone creating any
> type of dm device build out of multiple physical devices, and AFAIK, lvm
> doesn't bother to protect users against this, even though it can now
> autoassemble. So I'm not against dropping this either.
 
LVM operations are co-ordinated using a variety of locks in
/var/lock/lvm.  The prefix "A_" is used for the locks designed to avoid
concurrent activation attempts on the same volume.

Alasdair
