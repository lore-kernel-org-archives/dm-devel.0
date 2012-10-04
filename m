From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH v3 11/26] block: Add submit_bio_wait(), remove
 from md
Date: Thu, 04 Oct 2012 08:07:20 +0200
Message-ID: <506D2798.7060001@suse.de>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com> <1348526106-17074-12-git-send-email-koverstreet@google.com> <20121002194132.GF3283@redhat.com> <20121002201105.GL26488@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121002201105.GL26488@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, Vivek Goyal <vgoyal@redhat.com>, tj@kernel.org, axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 10/02/2012 10:11 PM, Kent Overstreet wrote:
> On Tue, Oct 02, 2012 at 03:41:32PM -0400, Vivek Goyal wrote:
>> On Mon, Sep 24, 2012 at 03:34:51PM -0700, Kent Overstreet wrote:
>>> Random cleanup - this code was duplicated and it's not really speci=
fic
>>> to md.
>>>
>>> Also added the ability to return the actual error code.
>>
>> Who is going to make use of actual error code and why checking
>> BIO_UPTODATE is not sufficient (as existing code is doing)?
>
> Some things do, though it's not common and I forget where I saw it -
> checking for -ENOTSUPPORTED vs. other stuff
>
There are also additional error codes like -ENOLINK when the nexus=20
is dropped. Quite useful in multipathed or clustered environs.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
