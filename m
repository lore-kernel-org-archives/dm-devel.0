From: Edward Thornber <thornber@redhat.com>
Subject: Re: dm-era: metadata reuse after reboot possible?
Date: Mon, 31 Oct 2016 07:37:50 -0400
Message-ID: <20161031113749.GA27906@roamer.bos.redhat.com>
References: <c06844f1-bed2-7de3-5338-67f6a9d84f5a@cloudandheat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <c06844f1-bed2-7de3-5338-67f6a9d84f5a@cloudandheat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Markus Hentsch <markus.hentsch@cloudandheat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Oct 21, 2016 at 11:29:26AM +0200, Markus Hentsch wrote:
> Hello,
> 
> is it possible for the dm-era metadata to survive reboots?

No, you certainly should be able to continue using the metadata.  I
don't have time to look at this for the next couple of weeks, but
after that will definitely fix.

- Joe
