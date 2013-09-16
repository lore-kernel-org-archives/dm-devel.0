From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: staging: Add dm-writeboost
Date: Tue, 17 Sep 2013 01:49:39 +0300
Message-ID: <20130916224939.GT25896@mwanda>
References: <5223208D.4000008@gmail.com>
 <20130916215357.GA5015@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20130916215357.GA5015@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, Akira Hayakawa <ruby.wktk@gmail.com>, dm-devel@redhat.com, cesarb@cesarb.net, joe@perches.com, akpm@linux-foundation.org, agk@redhat.com, m.chehab@samsung.com
List-Id: dm-devel.ids

On Mon, Sep 16, 2013 at 05:53:57PM -0400, Mike Snitzer wrote:
> - variable names need to be a bit more verbose (arr => array)

"struct array " is a horrible name.  :P  Please don't use either "arr"
or "array".

regards,
dan carpenter
