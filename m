From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Differentiating between dm devices
Date: Fri, 25 Mar 2011 14:34:50 -0400
Message-ID: <4D8CE04A.7080308@cfl.rr.com>
References: <4D8A2E53.10401@cfl.rr.com> <4D8AF181.4050004@suse.de>
	<4D8B0199.20806@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D8B0199.20806@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On 3/24/2011 4:32 AM, Milan Broz wrote:
> - kpartx uses prefix in format (part%N- where
> N is part number - my opinion it is bug but that up to discussion.
> My suggestion is to use KPARTX-part%N*)

So if kpartx creates the partition device instead of dmraid, the
partition will have a UUID of "part1-DMRAID-xyz"?  If that is the case,
then dmraid and lvm should be patched to use the same scheme don't you
think?  And then tools like parted can tell which devices are partitions
and which are not.
