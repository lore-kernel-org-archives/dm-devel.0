From: "Akinobu Mita" <akinobu.mita@gmail.com>
Subject: Re: [PATCH 2/4] void unregister_blkdev - delete redundant messages
Date: Sat, 30 Jun 2007 23:08:06 +0900
Message-ID: <961aa3350706300708l3bd4ab31ob9646847ea4f4537@mail.gmail.com>
References: <20070630031013.GC4045@APFDCB5C> <20070630031212.GD4045@APFDCB5C>
	 <fa686aa40706292314g3323c98dxdecd8b5a289f1c64@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758788AbXF3OIU@vger.kernel.org>
In-Reply-To: <fa686aa40706292314g3323c98dxdecd8b5a289f1c64@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Eberhard Moenkeberg <emoenke@gwdg.de>, Joe Thornber <dm-devel@redhat.com>
List-Id: dm-devel.ids

2007/6/30, Grant Likely <grant.likely@secretlab.ca>:
> On 6/29/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> > No need to warn unregister_blkdev() failure by the callers.
> > (The previous patch makes unregister_blkdev() print error message in
> > error case)
>
> Seeing as none of the callers check the error code; why does the
> function return anything at all?

Right. This series of patches is trying to make it return void.

http://lkml.org/lkml/2007/6/29/320
