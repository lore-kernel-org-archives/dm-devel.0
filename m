From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: Multipath tool for 2.6.9 RHEL 4 U1
Date: Thu, 05 May 2005 00:30:40 +0200
Message-ID: <1115245840.2277.43.camel@zezette>
References: <200505041242.AKZ26658@ind-mira-01.cisco.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200505041242.AKZ26658@ind-mira-01.cisco.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: smithan@cisco.com
Cc: 'Nitin Chandna' <cnitin@cisco.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On mer, 2005-05-04 at 18:17 +0530, Smitha Narayanaswamy (smithan) wrote:
> Hi,
> Which is the version of the multipath tool to be used for 2.6.9 RHEL 4
> U1 kernel?
> 
Depends on your objectives.

If you intend to do useful things with this server, you should stick
with to tools version provided by RedHat.

On the other hand, if you want to help with the development, you should
stick with upstream kernel+udm patches and upstream tools from
kernel.org git repository.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
