From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: cow snapshot on cloop device
Date: Wed, 24 Aug 2005 08:58:56 -0500
Message-ID: <200508241358.56758.kevcorry@us.ibm.com>
References: <6262291505082404352d0a4dc2@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6262291505082404352d0a4dc2@mail.gmail.com>
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

On Wed August 24 2005 11:35 am, Jacob Broido wrote:
> Hi,
> I am trying to set a cow snapshot on a cloop device.
> I managed to create a snapshot and mount it as read/write, but it appears
> that the data inside the /cloop appears invalid:
>
> Binary executables appear to be invalid, I perfomed diff between files on
> snapshotted /dev/cloop, and the same files accessed directly through cloop.
>
> The files were diffrent,
> anyone has idea as to what can be the reason for this?

Are you using LVM, EVMS, or dmsetup to create your snapshot? Please send in 
the output from "dmsetup ls" and "dmsetup table", as well as the contents 
of /proc/partitions and /proc/mounts, after you have activated and mounted 
your snapshot.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/
