From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-bufio
Date: Fri, 23 Mar 2012 17:32:21 -0400
Message-ID: <20120323213110.GA11054@redhat.com>
References: <CALLzPKZyOc+_Pjht8uR6AJOBsMFXQN=y5QWvD0_OZFaYJpvRig@mail.gmail.com>
	<4F6C5A1F.1000103@redhat.com>
	<CALLzPKb+xrQQ-+sOTY0-MHbfVDkgvY2TYqmpP0Mqi7XwD4iEDg@mail.gmail.com>
	<CALLzPKYkLXz0iZPwSbw268w1dkQtvjgoX19aVTK6cEAgt5L50g@mail.gmail.com>
	<20120323142133.GF7220@redhat.com>
	<CALLzPKa1qoaRcWzeh2sTz9PFhYmPSgpGicL0dQ3w1rsP4XhGUQ@mail.gmail.com>
	<20120323143254.GG7220@redhat.com>
	<CALLzPKZcArim2WxockC6mKfcDNBJxhqt6_yvNqmFV0tPm6Z40A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CALLzPKZcArim2WxockC6mKfcDNBJxhqt6_yvNqmFV0tPm6Z40A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dmitry.kasatkin@intel.com
Cc: device-mapper development <dm-devel@redhat.com>, mpatocka@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 23 2012 at 11:17am -0400,
Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:

> On Fri, Mar 23, 2012 at 4:32 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> > As an aside, just curious: what does your target do?
> 
> I have experimented with integrity protection.

Interesting.  Are you aware that a new integrity target has been
developed and is approaching upstream inclussion?  It is called
dm-verity.

Mikulas posted the most recent version here:
http://www.redhat.com/archives/dm-devel/2012-March/msg00133.html

And here is the userspace setup code:
http://www.redhat.com/archives/dm-devel/2012-March/msg00134.html

The original docs from Google's initial dm-verity are mostly applicable
(but need to be refreshed and included with the new version):
http://www.redhat.com/archives/dm-devel/2012-February/msg00119.html

dm-verity already has 2 formats, a 3rd could be added if you found the
existing formats somehow lacking, see:
http://www.redhat.com/archives/dm-devel/2012-March/msg00143.html

Mike
