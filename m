From: "Eli Malul" <eli.malul@kaminario.com>
Subject: Re: Huge memory allocation
Date: Thu, 3 Mar 2011 10:05:46 +0200
Message-ID: <E04C10E329E0CD40816C9C17AE53BBD301863EB0@kit001.kaminario.local>
References: <E04C10E329E0CD40816C9C17AE53BBD301863B7E@kit001.kaminario.local>
	<20110301134606.GN3626@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

I am expecting to have lots of (up to million) scattered extents across
some volumes which I am required to mirror.
Since mirror mapped device with a table that large consume unbearable
amount of memory (e.g. for 10,000 extents I saw about 6 Giga of memory
allocated by the device-mapper) I am going to create two linear devices
which maps these extents and mirror them.

In addition, I am required to preserve the original extent's offsets
since they are an existing user data used by DB applications.
To achieve that I will create another linear device to simulate the
original extent's offsets which shall be mapped to the created mirrored
device so, the client will continue to read and write the same offsets.

-----Original Message-----
From: Alasdair G Kergon [mailto:agk@redhat.com] 
Sent: Tuesday, March 01, 2011 3:46 PM
To: Eli Malul
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] Huge memory allocation

On Tue, Mar 01, 2011 at 03:04:56PM +0200, Eli Malul wrote:
> dm_malloc_aux do not allow memory allocation greater than 50000000.
 
That was to catch software bugs: it was a number bigger than ever
needed.  Change it if you need to, but I need stronger evidence
of the need for your particular way of doing things before
I'll change it in the upstream tree!

Alasdair
