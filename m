From: Spelic <spelic@shiftmail.org>
Subject: Re: dm-cache failure semantics in write-back mode
Date: Tue, 03 Mar 2015 22:58:00 +0100
Message-ID: <54F62E68.4040002@shiftmail.org>
References: <CAM2wQBtW2Bit2rx-1+hngUyh1gObtt+vjWQkDVWcTfm=axCyDw@mail.gmail.com>	<CAM2wQBsGay5cnTR+CO_BpSL8SiYiaQm-MnWFDQC_hG1AH3PcQw@mail.gmail.com>	<20150303161935.GA23166@debian>
	<CAM2wQBsS2hyA674CspKx6xZ49Fc1a=53UghaT5JkAPpjT3D_Ng@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAM2wQBsS2hyA674CspKx6xZ49Fc1a=53UghaT5JkAPpjT3D_Ng@mail.gmail.com>
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

On 03/03/2015 18:13, Thanos Makatos wrote:
> Thanks, Joe. So just to make sure I've understood correctly, if the 
> SSD cache is configured as a write-back cache but the device cache is 
> disabled/set to write-though on the HDD and the SSD, then there is no 
> risk of data loss in the event of a failure. Is my understanding correct?
>

You don't seem to understand the semantics of flush.
Writes on filesystems and databases are made more or less like a 
copy-on-write semantic:
- New data is written elsewhere
- a flush is issued
- when flush returns you are sure that such new data is on stable 
storage (disk platters or similar)
- change one pointer to point from old data to new data (so small that 
this change is atomic)
- flush again
when this flush returns you are sure that the data on-disk is updated.

Now you understand why dm-cache has the semantics that it has, which is 
the same semantics as DRAM caches on HDDs.

Applications writers have to follow the semantics described above, in 
order to have "atomic" updates on disk. This is true with dm-cache but 
also with DRAM caches on HDDs.
Partial data losses are irrelevant if the above logic is followed.

S.
