From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: Can anyone help me understand what is going wrong
 with a dm-multipah config I have?
Date: Mon, 25 Jan 2016 11:23:34 -0200
Message-ID: <56A621D6.5090909@linux.vnet.ibm.com>
References: <CACyXjPzV32k3oP2m2M4HaOcXtEAvcLA0jDDB=r+D=9AJ9y2Frg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CACyXjPzV32k3oP2m2M4HaOcXtEAvcLA0jDDB=r+D=9AJ9y2Frg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/18/2015 02:55 PM, Richard Sharpe wrote:
> Why does dm-multipath not switch to using the alternate paths?

I seem to recall one case where the iSCSI-related timeouts were not
set to lower values, for multipathing. So, failover took more time
than expected (ending up in the default value of 120 seconds iirc).

It was documented in the open-iscsi readme, section 8 advanced config
(includes topics for multipath configurations).

Additional references:
[1] 
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Online_Storage_Reconfiguration_Guide/iscsi-replacements_timeout.html
[2] 
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Online_Storage_Reconfiguration_Guide/iscsi-modifying-link-loss-behavior-dmmultipath.html


Hope this helps,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
