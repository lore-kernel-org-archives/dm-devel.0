From: Lan <transter@gmail.com>
Subject: Multipath Statistics
Date: Wed, 13 Apr 2005 10:41:49 -0700
Message-ID: <ac71172a05041310417117dd09@mail.gmail.com>
Reply-To: tranlan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

Hi all,

Thought it would be a good time to bring up a discussion on the type
of statistics that dm-multipath would find useful, e.g. for a load
balancing path selection algorithm or for users. This is a list of
statistics provided by an IBM multipathing product. (The discussion of
how to gather these type of statistics would also require another
discussion). Any thoughts/suggestions?

Per Path Information:	=20
- Number of times the path was selected for I/O
- Number of I/O errors on this path
=09
Per Adapter Information	:
- The number of times this adapter was selected for I/O
- The number of errors on all paths attached to this adapter
- The number of paths attached to this adapter
- The number of functional paths attached to this adapter (i.e.
Exclude failed or offline paths)
  =20
Path Performance Information (more specific breakdown):  =09
Total Read I/O:	Total number of completed read requests
Total Read Sector:	Total number of sectors that have been read
Total Write I/O:	Total number of completed write requests
Total Write Sector:	Total number of sectors that have been written
Active Read I/O:	Total number of read requests in process
Active Read Sector:	Total number of sectors to read in process
Active Write I/O:	Total number of write requests in process
Active Write Sector:	Total number of sectors to write in process
Maximum I/O:	The maximum number of active I/O requests
Maximum Sector:	The maximum number of active sectors to read or write
Transfer Size:=09
<=3D X , (X =3D {512, 4K, 16K, 64K})	The number of I/O requests received
whose transfer size is X bytes or less
> 64K 	The number of I/O requests received whose transfer size is greater=
 than 64KB
=09
Adapter Performance Information:
** identical to Path performance information except no "Transfer Size'" i=
nfo


Thanks!
Lan
