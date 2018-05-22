From: Anton Eliasson <anton.eliasson@axis.com>
Subject: dm-flakey: corrupt_bio_byte broken since Linux 4.0
Date: Tue, 22 May 2018 14:09:10 +0200
Message-ID: <63f315c1-6afb-bf71-4cba-3b6c181c7829@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-GB
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

Hi!

The corrupt_bio_byte feature of dm-flakey has been broken for a long 
time. In corrupt_bio_data(), bio_cur_bytes(bio) and bio_data(bio) always 
return 0 and NULL, so no data corruption is done. I believe this was 
caused by the integration of blk-mq in Linux 4.0. Through git bisecting 
I found that for underlying loop devices, this commit broke 
corrupt_bio_byte:

commit b5dd2f6047ca108001328aac0e8588edd15f1778
Author: Ming Lei <ming.lei@canonical.com>
Date:   Wed Dec 31 13:22:57 2014 +0000

     block: loop: improve performance via blk-mq

For underlying scsi devices it was broken some time before that.  If 
this conclusion is correct, does anyone have the time to fix dm-flakey 
by converting it to use blk-mq? I don't think I have the expertise to do 
it myself.

To test this feature I used the following commands to set up a flakey 
device that corrupts the first byte of the underlying device on reads:

         dd if=/dev/urandom of=disk bs=1M count=100
         losetup -f disk
         dmsetup create -r stuff <<< '0 204800 flakey /dev/loop0 0 1 100 
5 corrupt_bio_byte 1 r 0 0'
         dd if=disk count=1 status=none | hexdump
         dd if=/dev/dm-0 count=1 status=none | hexdump

Expected result is that the output from the two dd invocations differ in 
the first byte.

Thanks!

--
Anton Eliasson
