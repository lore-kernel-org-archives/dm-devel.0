From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: Fwd: cow snapshot on cloop device
Date: Thu, 25 Aug 2005 19:02:39 -0500
Message-ID: <200508251902.39765.kevcorry@us.ibm.com>
References: <6262291505082404352d0a4dc2@mail.gmail.com>
	<6262291505082410002ca214a9@mail.gmail.com>
	<6262291505082410015647272d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6262291505082410015647272d@mail.gmail.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Jacob Broido <jacob.broido@gmail.com>
List-Id: dm-devel.ids

Hi Jacob,

On Wed August 24 2005 12:01 pm, Jacob Broido wrote:
> ---------- Forwarded message ----------
> From: Jacob Broido <jacob.broido@gmail.com>
> Date: Aug 24, 2005 7:00 PM
> Subject: Re: [dm-devel] cow snapshot on cloop device
> To: Kevin Corry <kevcorry@us.ibm.com>
>
> I am using dmsetup directly. and I do the following:
> 1) Create an empty file that will be used as cow backing storage
> 2) losetup the backing file to /dev/loop0
> 3) create a snapshot of main root_device on /dev/loop0
> 4) mount the cow snapshot
>
>
> Here is the info you requested:
> The kernel is a - 2.6.11.10 <http://2.6.11.10> + xen patch.
> =======================================================
> / # dmsetup ls
> root_master (253, 0)
> root_cow0 (253, 1)
> / # dmsetup table
> root_master: 0 4096128 linear 240:0 0
> root_cow0: 0 4096128 snapshot 253:0 7:0 P 8

Ok, this is not going to do what you're expecting it to do. In order to use 
snapshotting, you need a snapshot device, and you also need a snapshot-origin 
device. The snapshot-origin code is what monitors the I/O path for the origin 
device, and performs the copy-on-writes as necessary.

Last summer I did a write-up how you might use dmsetup to create snapshots. 
You can read the thread at:
https://www.redhat.com/archives/dm-devel/2004-July/msg00068.html

But in short, it's vastly simpler to just use LVM2 or EVMS to create 
snapshots. You should be able to create volumes on your cloop devices using 
either set of tools.

Let me know if you have additional questions after reading through the thread 
above.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/
