From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
Date: Sun, 10 Oct 2010 17:34:50 +0200
Message-ID: <4CB1DD1A.5080906@redhat.com>
References: <20101010115941.GA8539@basil.fritz.box> <4CB1B3B9.4030205@redhat.com> <20101010130842.GE8256@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101010130842.GE8256@basil.fritz.box>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>, device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

On 10/10/2010 03:08 PM, Andi Kleen wrote:
> I did it intentionally not split up because a split up is unlikely
> to be bisectable. I think there is no need for any splitups.

Shrug. The main encryption thread and ESSIV per-cpu are two separate
things from my point of view.

Anyway, the ball is on DM maintainer's playground now.

Milan
