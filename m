From: thornber@redhat.com
Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching software for
 Linux kernel
Date: Fri, 18 Jan 2013 14:43:46 +0000
Message-ID: <20130118144345.GA3077@raspberrypi>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
 <20130116104546.GA3869@raspberrypi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130116104546.GA3869@raspberrypi>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, Jan 16, 2013 at 10:45:47AM +0000, thornber@redhat.com wrote:
> I'll create a branch in my github tree with all three caches in.  So
> it's easy to build a kernel with them.  (Mike's already combined
> dm-cache and bcache and done some preliminary testing).

git://github.com/jthornber/linux-2.6.git

branch 'all-caches'

I managed to reproduce the hang with bcache that Mike described
before.  However I can see that it was running the test more quickly
than eio at this point.

- Joe
