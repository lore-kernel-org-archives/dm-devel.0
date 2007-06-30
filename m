From: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/4] void unregister_blkdev - delete redundant messages
Date: Sat, 30 Jun 2007 02:14:55 -0400
Message-ID: <fa686aa40706292314g3323c98dxdecd8b5a289f1c64@mail.gmail.com>
References: <20070630031013.GC4045@APFDCB5C> <20070630031212.GD4045@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754670AbXF3GPJ@vger.kernel.org>
In-Reply-To: <20070630031212.GD4045@APFDCB5C>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org, Eberhard Moenkeberg <emoenke@gwdg.de>, Joe Thornber <dm-devel@redhat.com>, Grant Likely <grant.likely@secretlab.ca>
List-Id: dm-devel.ids

On 6/29/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> No need to warn unregister_blkdev() failure by the callers.
> (The previous patch makes unregister_blkdev() print error message in
> error case)

Seeing as none of the callers check the error code; why does the
function return anything at all?

g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
