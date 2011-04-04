From: =?ISO-8859-1?Q?Gr=E9goire_Pichon?= <gregoire.pichon@bull.net>
Subject: IO errors when tuning max_sectors_kb value of a dm device
Date: Mon, 04 Apr 2011 18:24:11 +0200
Message-ID: <4D99F0AB.90406@bull.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

If dm-devel is the good list to ask questions, could anyone have a look 
at my problem ?

I observe some IO errors on a multipath device for which the 
max_sectors_kb parameter has been tunned. Value is increased from the 
default (1024) to the value of the hw max sectors (32768).

The following error appears in the system log:
     1301326968 2011 Mar 28 17:42:48 berlin4 kern err kernel 
blk_rq_check_limits: over max size limit.
Followed by several I/O errors
     1301326968 2011 Mar 28 17:42:48 berlin4 kern err kernel 
end_request: I/O error, dev dm-10, sector 26624
     1301326968 2011 Mar 28 17:42:48 berlin4 kern err kernel 
end_request: I/O error, dev dm-10, sector 24576
     1301326968 2011 Mar 28 17:42:48 berlin4 kern err kernel 
end_request: I/O error, dev dm-10, sector 22528
     ...

I have seen in the device-mapper source code that when a multipath 
device is configured, its limits are computed from a combination of all 
the slave devices it uses (dm_calculate_queue_limits()).

Does it mean that tuning the dm device is forbidden ?
Is there way to re-validate the queue limits after the tuning ?

Do you think it would be safe if I additionally tune the max_sectors_kb 
parameter of the slave devices ?

Thanks in advance,
Gregoire.
