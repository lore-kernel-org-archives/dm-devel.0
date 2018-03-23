From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v2 3/5] libmultipath: config parser: Allow
 '"' in strings
Date: Fri, 23 Mar 2018 17:59:52 +0100
Message-ID: <e505286a-9dbf-969a-f638-7de33262067c@gmail.com>
References: <20180307232620.15746-1-mwilck@suse.com>
	<20180307232620.15746-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307232620.15746-4-mwilck@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 03/08/2018 12:26 AM, Martin Wilck wrote:

> We have seen model strings lile '2.5" SSD' which can't be parsed
> by the current config parser. This patch fixes this by allowing
> '""' to represent a double quote character inside a a string.
> The above model string could now be entered in the config file like this:
> 
> blacklist {
> 	  vendor SomeCorp
> 	  product "2.5"" SSD"
> }


Could this work in the first place?

          product "2.5\" SSD"
