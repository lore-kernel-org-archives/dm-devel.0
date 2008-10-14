From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Can I configure priority?
Date: Tue, 14 Oct 2008 23:25:28 +0200
Message-ID: <20081014232528.24e82a3c@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: scmoseman@gmail.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

> RHEL v5
> eth + hba
> 
> If I'm using 'multibus' for my 'path_grouping_policy' in order to
> utilize all of the channels, is there any way to prioritize how the 2
> interfaces are used?  For instance, if we prefer to have the traffic,
> when the bandwidth doesn't exceed a single channel, using the HBA
> first and ETH second?  How does DM determine which interface to use in
> low bandwidth situations?
> 
> Thanks,
> Scott
> 
With a multibus multipath, you can still use path priorities as a
weighting factor for the (weighted) round-robin scheduler :

1/ set "rr_weight priorities" in multipath.conf
2/ find or forge a priority handler to return the weights your want for
your paths

Regards,
cvaroqui
