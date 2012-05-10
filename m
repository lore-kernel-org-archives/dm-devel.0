From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [Bcache v13 02/16] Bio pool freeing
Date: Thu, 10 May 2012 14:53:03 -0700
Message-ID: <CAH+dOx+8jmSQSF2PqPb6aq3c3NsyyOOvycujbANNm6V6qBbd_Q@mail.gmail.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<ba8ce9fcca87f192ff5f5d3a436eb8f4d0bcb006.1336619038.git.koverstreet@google.com>
	<20120510213217.GN23768@redhat.com>
	<CAH+dOxL7QwcyUm46cK-pF1qK+kHYC=67iAaQDDwUF2ssJwergA@mail.gmail.com>
	<20120510215208.GC2613@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120510215208.GC2613-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Thu, May 10, 2012 at 2:52 PM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> ok, probably we could explain it more in changelog or push this in same
> patch where you introduce bio splitting so that bio shares bvec with other
> bio. That way it is easier to understand.

Yeah, agreed.
