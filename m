From: Scott Bauer <scott.bauer@intel.com>
Subject: Re: [PATCH 1/4] dm unstriped: support non power of 2
	chunk size
Date: Tue, 6 Feb 2018 11:02:01 -0700
Message-ID: <20180206180200.o33ymhaklzbax7aa@sbauer-Z170X-UD5>
References: <cover.1517504857.git.heinzm@redhat.com>
	<5fb708419717b6a0508de258f061cdefc8538a8c.1517504857.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5fb708419717b6a0508de258f061cdefc8538a8c.1517504857.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Feb 01, 2018 at 07:09:46PM +0100, Heinz Mauelshagen wrote:
> Address "FIXME: must support non power of 2 chunk_size, dm-stripe.c does".
> 
> Bump target version to indicate change.
> 
> Allow for module loading adding alias as long as we keep dm-unstripe.ko.
> 
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Looks good:

Tested-by: Scott Bauer <Scott.Bauer@intel.com>
Reviewed-by: Scott Bauer <Scott.Bauer@intel.com>
