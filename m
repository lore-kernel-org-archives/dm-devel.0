From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 26/78] 11-dm-mpath.rules: Import blkid values
 if all paths are down
Date: Fri, 27 Mar 2015 17:03:06 +0100
Message-ID: <55157F3A.3030600@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
	<1426509425-15978-27-git-send-email-hare@suse.de>
	<20150327034242.GQ29132@octiron.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150327034242.GQ29132@octiron.msp.redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 03/27/2015 04:42 AM, Benjamin Marzinski wrote:
> On Mon, Mar 16, 2015 at 01:36:13PM +0100, Hannes Reinecke wrote:
>> When all paths are failed we should not try to run any programs
>> requiring disk access. However, we still need to create the
>> symlinks so as not to confuse systemd.
>> So import the blkid values from the database in these cases.
> =

> Don't we still need to set DM_NOSCAN here?
> =

I have no idea at all. I just found the setting somewhere and
thought it'd be a good idea.
But don't ask me what's for; device-mapper/LVM udev variables
are an arcane subject which I've yet to grasp.

Incidentally, a similar fix is needed for 10-dm.rules.
But I'll prepare a separate patch for this.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
