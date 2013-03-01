From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [patch] dm-cache-target: check for allocation failure
Date: Fri, 1 Mar 2013 21:36:33 +0000
Message-ID: <20130301213632.GE8373@agk.fab.redhat.com>
References: <20130301202641.GA22066@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130301202641.GA22066@longonot.mountain>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alasdair Kergon <agk@redhat.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, kbuild@01.org, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Mar 01, 2013 at 11:26:41PM +0300, Dan Carpenter wrote:
> The allocation here isn't checked.  I changed it to using kcalloc()
> as a cleanup.  It adds integer overflow checking as well which makes
> the code easier to audit.
 
Folded it in - thanks.

Alasdair

