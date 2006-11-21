From: Kalpak Shah <kalpak@linsyssoft.com>
Subject: Breaking of large IO requests into small bios by
	device-mapper
Date: Tue, 21 Nov 2006 19:20:10 +0800
Message-ID: <1164108010.2925.15.camel@garfield>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

Hi I am checking if device-mapper breaks down the reads/writes which are
sent by the file system. For example if an FS like Lustre sends a 1MB
read/write whether the request goes to the disk as a single request or
is it broken down into many small requests.

I have put some printks in __map_bio, __split_bio, etc. It seems that
even though 1 MB writes are sent to the device mapper the bios that are
sent to generic_make_request in __map_bio are at max 8k in size. In
function max_io_len(), ti->split_io is just 16 sectors at max, hich is
why the requests get broken down.

Why is this ->split_io variable set to 16 sectors? Can it  be more (arnd
2048 sectors) without affecting the stability?

Thanks,
Kalpak.
