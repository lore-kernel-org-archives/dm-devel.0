From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Possible bug in mirror target
Date: Wed, 13 Feb 2019 15:01:41 +0000
Message-ID: <20190213150141.GC26740@localhost.localdomain>
References: <CAN-y+EKdQnRWck4B3Ms0ZGHqEL4+V+xPb-G3vhPy+Qe0DMO0oA@mail.gmail.com>
	<27e658d7-265f-b765-1b19-d61f52da8457@redhat.com>
	<23648.40558.660430.523285@quad.stoffel.home>
	<84219415-de11-5b28-ec2f-68ee7e74c4b0@redhat.com>
	<23651.19067.298943.820452@quad.stoffel.home>
	<64d236db-20d9-35f6-83d8-bf81cb4b8fb5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <64d236db-20d9-35f6-83d8-bf81cb4b8fb5@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com, John Stoffel <john@stoffel.org>, Drew Hastings <dhastings@crucialwebhost.com>
List-Id: dm-devel.ids

On Wed, Feb 13, 2019 at 03:21:52PM +0100, Zdenek Kabelac wrote:
> If you have this free space it's surely not a bad thing - but there
> are many cases, you can get any free space - majority of filesystems
> does not support shrinking - so the only 'free' space you can
> get is by adding new storage to VG - again quite limiting factor.

Probably obvious to many, but if you find yourself in this situation
using the Red Hat / Fedora default layout created by Anaconda, the
easiest solution is normally to "steal" one extent from the auto-
configured swap LV, and donate it to the mirror conversion:

  # swapoff -a
  # lvresize -l -1 rhel/swap
  # mkswap /dev/rhel/swap
  # swapon -a
  # lvchange -m1 ...

This will always work with the automatic layouts provided by those
distros.

Regards,
Bryn.
