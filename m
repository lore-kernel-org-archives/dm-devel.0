From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH] kpartx: support device names with spaces
Date: Wed, 20 Jan 2016 11:57:54 -0200
Message-ID: <569F9262.90305@linux.vnet.ibm.com>
References: <1452191515-4027-1-git-send-email-mauricfo@linux.vnet.ibm.com>
	<CABr-GncCqpkdNcw4ShHxigHKqB+feesNDoUHHfkR_1vkJQ5BmA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GncCqpkdNcw4ShHxigHKqB+feesNDoUHHfkR_1vkJQ5BmA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Christophe,

On 01/20/2016 05:15 AM, Christophe Varoqui wrote:
> shouldn't you either define the MAJOR and MINOR macros, or include the
> appropriate kernel header ? As is the build emits :

Oops. Apologies. I incorrectly submitted a backport of the patch.

I just submitted V2 w/ the right patch, which uses major()/minor()
as elsewhere in the file.  The build and test-case are OK. Thanks!

Regards,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
