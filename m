From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 10/57] docs: device-mapper: convert it to ReST format
Date: Tue, 16 Apr 2019 11:27:23 -0600
Message-ID: <20190416112723.66b4bd4a@lwn.net>
References: <cover.1555382110.git.mchehab+samsung@kernel.org>
        <9dd3c4eca01489bd67ea6de88dfedef8b0e81901.1555382110.git.mchehab+samsung@kernel.org>
        <20190416132851.GA22497@redhat.com>
        <20190416080024.7fb65682@lwn.net>
        <20190416154858.GB22497@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190416154858.GB22497@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 16 Apr 2019 11:48:59 -0400
Mike Snitzer <snitzer@redhat.com> wrote:

> Think the last piece I'm missing is: how does one edit a .rst document
> without having to know to sprinkle syntactic sugar around?  Does emacs
> have a ReST mode?  If not what client interface are people using to
> properly change these documents?

There is an RST mode for Emacs, yes.  But you likely don't really need
it.  RST is a simple format and, in general, we try to keep the markup to
a minimum so that the plain-text files remain as readable as possible.
Most of our documents are 99% RST before anybody gets around to formally
converting them.

> (apologies if this is all spelled out nicely in Documentation/
> somewhere, but please help this man learn to fish).

Basics in Documentation/doc-guide (or
https://www.kernel.org/doc/html/latest/doc-guide/index.html).  There's
also some history and overview in:

	https://lwn.net/Articles/692704/
	https://lwn.net/Articles/692705/

Thanks,

jon
