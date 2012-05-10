From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [Bcache v13 00/16]
Date: Thu, 10 May 2012 08:34:04 -0700
Message-ID: <CAH+dOxJuubWJ5cRa=Xb4SFuH8wvCaKsF-DfN8bDpQNOtB4_WCA@mail.gmail.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<20120510150353.GI23768@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120510150353.GI23768-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Thu, May 10, 2012 at 8:03 AM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, May 09, 2012 at 11:07:29PM -0400, Kent Overstreet wrote:
>
> [..]
>> The userspace interface is going to change before it goes in. The general
>> consensus at LSF was that we don't want yet another interface for
>> probing/managing block devices, and dm exists so we may as well use that. I
>> don't think anyone's started on that yet, though.
>>
>
> Ok, I missed above lines and was pointed to it. So idea of this posting is
> to review core changes and then somebody else needs to take the core, wrap
> it with dm apis and repost?

More or less - I'm not sure who's going to be doing the dm integration
work (I honestly don't have time), but it's not been forgotten. But
there's other stuff that needs review in the meantime.
