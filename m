From: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/4] void unregister_blkdev - delete redundant messages
Date: Sat, 30 Jun 2007 10:12:53 -0400
Message-ID: <fa686aa40706300712w306243e0ob1242ebc28442071@mail.gmail.com>
References: <20070630031013.GC4045@APFDCB5C> <20070630031212.GD4045@APFDCB5C>
	 <fa686aa40706292314g3323c98dxdecd8b5a289f1c64@mail.gmail.com>
	 <961aa3350706300708l3bd4ab31ob9646847ea4f4537@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758380AbXF3ONG@vger.kernel.org>
In-Reply-To: <961aa3350706300708l3bd4ab31ob9646847ea4f4537@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eberhard Moenkeberg <emoenke@gwdg.de>, Joe Thornber <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 6/30/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> > Seeing as none of the callers check the error code; why does the
> > function return anything at all?
>
> Right. This series of patches is trying to make it return void.
>
> http://lkml.org/lkml/2007/6/29/320

Heh, cool.  I should do more research before I reply blindly.  :-)

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
