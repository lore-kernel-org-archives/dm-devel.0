From: Barry Kauler <bkauler@gmail.com>
Subject: Re: [PATCH v5 0/3] init: add support to directly boot to
 a mapped device
Date: Fri, 18 Nov 2016 07:04:02 +0800
Message-ID: <CABWT5yhkajSuMBfvwRopyuPgkGRmQMpjuRgEvUfVBe4Au3xQiQ@mail.gmail.com>
References: <CABWT5yhN6C91gwiA6hJJR0FfAjFK6goYha0PsMV=rSEu1gVsBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABWT5yhN6C91gwiA6hJJR0FfAjFK6goYha0PsMV=rSEu1gVsBQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Barry Kauler wrote:
> However, it seems that the 'table' format when using 'dmsetup create',
> and also in the kernel boot params, that devices can only be specified
> by the normal name (/dev/sd*) or by major:minor numbers.

> basically, my question is, could the 'table' format be extended to
> accept PARTUUIDs, either the GUID format as used in GPT drives (use
> 'gdisk' to get it), or <NT disk identifier>-<partition number> format
> for MBR disks.

Here is one of the relevant posts from Kees Cook, Feb. 2016, with v5 patch:

https://www.redhat.com/archives/dm-devel/2016-February/msg00112.html

Regards,
Barry Kauler
