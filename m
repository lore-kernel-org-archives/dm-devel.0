From: "Eli Malul" <eli.malul@kaminario.com>
Subject: Re: mirrored device with thousand of mapping tableentries
Date: Mon, 28 Feb 2011 13:59:16 +0200
Message-ID: <E04C10E329E0CD40816C9C17AE53BBD3018639CE@kit001.kaminario.local>
References: <E04C10E329E0CD40816C9C17AE53BBD3018639C2@kit001.kaminario.local>
	<20110228114801.GZ3626@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20110228114801.GZ3626@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

The first few lines of the table I am loading:
[root@vpc09 ~]# vi /tmp/mirror_table.txt
0 12 km_mirror core 2 8 nosync 2 /dev/loop0 0 /dev/loop1 0
12 12 km_mirror core 2 8 nosync 2 /dev/loop0 12 /dev/loop1 12
24 12 km_mirror core 2 8 nosync 2 /dev/loop0 24 /dev/loop1 24
36 12 km_mirror core 2 8 nosync 2 /dev/loop0 36 /dev/loop1 36
48 12 km_mirror core 2 8 nosync 2 /dev/loop0 48 /dev/loop1 48
60 12 km_mirror core 2 8 nosync 2 /dev/loop0 60 /dev/loop1 60
72 12 km_mirror core 2 8 nosync 2 /dev/loop0 72 /dev/loop1 72
84 12 km_mirror core 2 8 nosync 2 /dev/loop0 84 /dev/loop1 84
96 12 km_mirror core 2 8 nosync 2 /dev/loop0 96 /dev/loop1 96
108 12 km_mirror core 2 8 nosync 2 /dev/loop0 108 /dev/loop1 108
.
.
.

I am also adding the result of the 'free' command so you can see the
memory usage increasing:

[root@vpc09 ~]# free -g
             total       used       free     shared    buffers
cached
Mem:             7          0          6          0          0
0
-/+ buffers/cache:          0          7
Swap:            0          0          0
[root@vpc09 ~]# free -g
             total       used       free     shared    buffers
cached
Mem:             7          6          0          0          0
0
-/+ buffers/cache:          6          1
Swap:            0          0          0

-----Original Message-----
From: Alasdair G Kergon [mailto:agk@redhat.com] 
Sent: Monday, February 28, 2011 1:48 PM
To: device-mapper development
Subject: Re: [dm-devel] mirrored device with thousand of mapping
tableentries

On Mon, Feb 28, 2011 at 01:21:10PM +0200, Eli Malul wrote:
> 1.       Did anyone tried before to create a mirrored device with
> thousands of targets?
> 2.       What is the estimated total allocated memory per each target?
> 3.       Is there something I am missing here?
 
Please show us an example, maybe the first few lines of the tables you
are loading.

Alasdair
