From: Spelic <spelic@shiftmail.org>
Subject: How to reissue stuck inflight i/o
Date: Tue, 26 Nov 2013 18:54:14 +0100
Message-ID: <5294E046.409@shiftmail.org>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello all,
we just had a case in which some I/Os were apparently stuck inflight in 
an LV aka DM (visible in iostat as nonzero avgqu-sz for an dm-X device) 
for a long time, such as at least 20 minutes, but all layers below it 
had zero inflight I/O (MD RAID and then the disks), so DM and the above 
layers were waiting endlessly.
This was with an old kernel 2.6.24-something .
I wasn't able to debug further. After 30 minutes or so it resolved by 
itself without leaving anything in dmesg or anywhere else.

Is there a way to reissue inflight I/O to lower layers (such as what 
happens transparently with the 5 SCSI retries after SCSI timeout) for 
DM, or at least kill such I/O so that above layers receive an I/O error 
and move on?
I was thinking at some dmsetup command but was not clear to me which.
What about a dmsetup suspend and then resume? I didn't think about 
trying this, at that time.

Thanks
S.
