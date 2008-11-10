From: Phillip Susi <psusi@cfl.rr.com>
Subject: Error target causes entire device to error
Date: Mon, 10 Nov 2008 17:16:28 -0500
Message-ID: <4918B2BC.8020606@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

$ sudo dmsetup create foo
0 1 zero
1 1 error
$ sudo dd if=/dev/mapper/foo bs=512 count=1
dd: reading `/dev/mapper/foo': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000715356 seconds, 0.0 kB/s

Why can't you read the first sector mapped to the zero target without 
getting an error?  It doesn't seem to matter where the error target is 
in the table, or how big the virtual device is; any attempt to read 
anywhere returns an error if there are any sectors mapped to the error 
target.
