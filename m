From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Can I configure priority?
Date: Tue, 14 Oct 2008 13:08:49 -0500
Message-ID: <342d47870810141108n6557befbs620a24bac96b5391@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

RHEL v5
eth + hba

If I'm using 'multibus' for my 'path_grouping_policy' in order to
utilize all of the channels, is there any way to prioritize how the 2
interfaces are used?  For instance, if we prefer to have the traffic,
when the bandwidth doesn't exceed a single channel, using the HBA
first and ETH second?  How does DM determine which interface to use in
low bandwidth situations?

Thanks,
Scott
