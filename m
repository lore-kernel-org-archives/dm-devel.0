From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH 10/57] docs: device-mapper: convert it to ReST format
Date: Tue, 16 Apr 2019 11:33:16 -0300
Message-ID: <20190416113316.5c3b496c@coco.lan>
References: <cover.1555382110.git.mchehab+samsung@kernel.org>
        <9dd3c4eca01489bd67ea6de88dfedef8b0e81901.1555382110.git.mchehab+samsung@kernel.org>
        <20190416132851.GA22497@redhat.com>
        <20190416080024.7fb65682@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190416080024.7fb65682@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Snitzer <snitzer@redhat.com>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Em Tue, 16 Apr 2019 08:00:24 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Tue, 16 Apr 2019 09:28:52 -0400
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > Can you help me understand why this is the direction text based
> > Documenation is taking in the Linux kernel?  All I see is markup, and
> > escaping of characters, that is a chore to administer over time.  
> 
> This is a discussion that was mostly resolved some years ago...
> 
> Classic Documentation/ is a jumbled collection of unorganized text files,
> some of which contain highly useful information and others of which
> haven't had much to offer since about 1996.  We are working to turn it
> into an organized collection where, hopefully, some thought has actually
> been given to the people who will be reading it.
> 
> The ReST conversion, in particular, allows us to link documents into a
> larger structure, create indexes and cross references, and produce output
> in formats like HTML and PDF.  It lets us present the documentation like
> this:
> 
> 	https://www.kernel.org/doc/html/latest/

Just to mention, in the specific case of the device-mapper patch,
this is the result of those changes (after renaming the files to .rst,
and adding an index file):

	https://www.infradead.org/~mchehab/rst_conversion/device-mapper/index.html

> 
> Among other things, making the documentation more accessible in this way
> makes it easier and more rewarding for developers to improve it, and I
> believe we are seeing the results of that.  Linus called out the
> documentation work in the 5.1-rc1 announcement, for example.
> 
> Nobody has complained about the maintenance burden of RST docs - so far as
> I have heard, anyway.  Things do break occasionally, but problems in the
> docs build almost always result from code changes that mess up the
> kerneldoc comments rather than RST changes, and it's been that way for as
> long as I've been paying attention.


> 
> Thanks,
> 
> jon



Thanks,
Mauro
