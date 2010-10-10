From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
Date: Sun, 10 Oct 2010 14:53:54 +0200
Message-ID: <4CB1B762.90900@redhat.com>
References: <20101010115941.GA8539@basil.fritz.box> <4CB1B3B9.4030205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CB1B3B9.4030205@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <ak@linux.intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, pedrib@gmail.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 10/10/2010 02:38 PM, Milan Broz wrote:

> is there some change in your new version?
Of course I mean except the changes you mentioned which are easy
to change in my patchset:-)

(There was requirement from agk to have several simple
bisectable patches.)
 
> Can I send this to dm-devel instead? 
(I mean with the v3 CPU intensive workqueue changes of course)

In any case, it should be merged ASAP
to allow more people to test it.

Milan
