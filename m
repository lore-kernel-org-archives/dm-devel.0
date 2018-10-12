From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 5/8] multipath.8: man page update
Date: Fri, 12 Oct 2018 16:51:28 -0500
Message-ID: <20181012215128.GH29125@octiron.msp.redhat.com>
References: <20181010200506.15796-1-mwilck@suse.com>
	<20181010200506.15796-6-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181010200506.15796-6-mwilck@suse.com>
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

On Wed, Oct 10, 2018 at 10:05:03PM +0200, Martin Wilck wrote:
> Clean up the synopsis, listing only combinations of command line switches
> that work and make sense. Split the switches between "operation modes"
> and options. Fix the documentation of the -v switch, which was wrong.
> Move the description of the "device" argument to the top. Link to
> multipath.conf(5) for the description of the path grouping policy rather
> than repeating the content here. Various minor improvements and clarifications.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/multipath.8 | 273 ++++++++++++++++++++++++++----------------
>  1 file changed, 167 insertions(+), 106 deletions(-)
> 
> diff --git a/multipath/multipath.8 b/multipath/multipath.8
> index b5e5292f..c9bd23aa 100644
> --- a/multipath/multipath.8
> +++ b/multipath/multipath.8
> @@ -5,7 +5,7 @@
>  .\"
>  .\" ----------------------------------------------------------------------------
>  .
> -.TH MULTIPATH 8 2016-10-26 "Linux"
> +.TH MULTIPATH 8 2018-10-10 "Linux"
>  .
>  .
>  .\" ----------------------------------------------------------------------------
> @@ -21,17 +21,68 @@ multipath \- Device mapper target autoconfig.
>  .
>  .B multipath
>  .RB [\| \-v\ \c
> -.IR verbosity \|]
> +.IR level \|]
> +.RB [\| \-B | \-d | \-i | \-q | \-r \|]
>  .RB [\| \-b\ \c
> -.IR bindings_file \|]
> -.RB [\| \-d \|]
> -.RB [\| \-h | \-l | \-ll | \-f | \-t | \-T | \-F | \-B | \-c | \-C | \-q | \-r | \-i | \-a | \-u | \-U | \-w | \-W \|]
> +.IR file \|]
>  .RB [\| \-p\ \c
> -.IR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
> +.IR policy \|]
> +.RB [\| device \|]
> +.
> +.LP
> +.B multipath
> +.RB [\| \-v\ \c
> +.IR level \|]
>  .RB [\| \-R\ \c
>  .IR retries \|]
> +.B \-f device
> +.
> +.LP
> +.B multipath
> +.RB [\| \-v\ \c
> +.IR level \|]
> +.RB [\| \-R\ \c
> +.IR retries \|]
> +.B \-F
> +.
> +.LP
> +.B multipath
> +.RB [\| \-v\ \c
> +.IR level \|]
> +.RB [\| \-l | \-ll \|]
>  .RB [\| device \|]
>  .
> +.LP
> +.B multipath
> +.RB [\| \-v\ \c
> +.IR level \|]
> +.RB [\| \-a | \-w \|]
> +.B device
> +.
> +.LP
> +.B multipath
> +.RB [\| \-v\ \c
> +.IR level \|]
> +.B -W
> +.
> +.LP
> +.B multipath
> +.RB [\| \-v\ \c
> +.IR level \|]
> +.RB [\| \-i \|]
> +.RB [\| \-c | \-C \|]
> +.B device
> +.
> +.LP
> +.B multipath
> +.RB [\| \-v\ \c
> +.IR level \|]
> +.RB [\| \-i \|]
> +.RB [\| \-u | \-U \|]
> +.
> +.LP
> +.B multipath
> +.RB [\| \-h | \-t | \-T \|]
>  .
>  .\" ----------------------------------------------------------------------------
>  .SH DESCRIPTION
> @@ -40,83 +91,62 @@ multipath \- Device mapper target autoconfig.
>  .B multipath
>  is used to detect and coalesce multiple paths to devices, for fail-over or performance reasons.
>  .
> -.
>  .\" ----------------------------------------------------------------------------
> -.SH OPTIONS
> +.SH ARGUMENTS
>  .\" ----------------------------------------------------------------------------
>  .
>  .TP
> -.BI \-v " level"
> -Verbosity, print all paths and multipaths:
> +.BI device
> +Act only on the multipath map specified by
> +.IR device ,
> +which is either:
>  .RS 1.2i
> -.TP 1.2i
> -.I 0
> -No output.
> -.TP
> -.I 1
> -Print the created or updated multipath names only, for use to feed other tools like kpartx.
> -.TP
> -.I 2 +
> -Print all info: detected paths, coalesced paths (ie multipaths) and device maps.
> -.RE
> -.
> -.TP
> -.B \-h
> -Print usage text.
> -.
> -.TP
> -.B \-d
> -Dry run, do not create or update devmaps.
> +.IP \[bu]
> +A multipath map name.
> +.IP \[bu]
> +A path (low-level device) associated with the desired multipath map; the path may be in one of the following formats:
> +.RS 1.2i
> +.IP \[bu]
> +.B /dev/sdX
> +.IP \[bu]
> +.B major:minor

The device can also be a WWID. Otherwise this looks great.

-Ben

>  .
> -.TP
> -.B \-l
> -Show the current multipath topology from information fetched in sysfs and the device mapper.
> +.\" ----------------------------------------------------------------------------
> +.SH OPERATION MODES
> +.\" ----------------------------------------------------------------------------
>  .
> -.TP
> -.B \-ll
> -Show the current multipath topology from all available information (sysfs, the device mapper, path checkers ...).
> +The default operation mode is to detect and set up multipath maps from the devices found in
> +the system.
>  .
> +Other operation modes are chosen by using one of the following command line switches:
>  .TP
>  .B \-f
> -Flush a multipath device map specified as parameter, if unused.
> +Flush (remove) a multipath device map specified as parameter, if unused.
>  .
>  .TP
>  .B \-F
> -Flush all unused multipath device maps.
> -.
> -.TP
> -.B \-t
> -Display the currently used multipathd configuration.
> +Flush (remove) all unused multipath device maps.
>  .
>  .TP
> -.B \-T
> -Display the currently used multipathd configuration, limiting the output to
> -those devices actually present in the system. This can be used a template for
> -creating \fImultipath.conf\fR.
> +.B \-l
> +Show ("list") the current multipath topology from information fetched in sysfs and the device mapper.
>  .
>  .TP
> -.B \-r
> -Force devmap reload.
> +.B \-ll
> +Show ("list") the current multipath topology from all available information (sysfs, the
> +device mapper, path checkers ...).
>  .
>  .TP
> -.B \-i
> -Ignore WWIDs file when processing devices. If
> -\fIfind_multipaths strict\fR or \fIfind_multipaths no\fR is set in
> -\fImultipath.conf\fR, multipath only considers devices that are
> -listed in the WWIDs file. This option overrides that behavior. For other values
> -of \fIfind_multipaths\fR, this option has no effect. See the description of
> -\fIfind_multipaths\fR in
> -.BR multipath.conf (5).
> -This option should only be used in rare circumstances.
> +.B \-a
> +Add the WWID for the specified device to the WWIDs file.
>  .
>  .TP
> -.B \-B
> -Treat the bindings file as read only.
> +.B \-w
> +Remove the WWID for the specified device from the WWIDs file.
>  .
>  .TP
> -.BI \-b " bindings_file"
> -Set user_friendly_names bindings file location.  The default is
> -\fI/etc/multipath/bindings\fR.
> +.B \-W
> +Reset the WWIDs file to only include the current multipath devices.
>  .
>  .TP
>  .B \-c
> @@ -129,14 +159,6 @@ test whether or not I/O on this device is likely to succeed. The command
>  itself doesn't attempt to do I/O on the device.
>  .
>  .TP
> -.B \-q
> -Allow device tables with \fIqueue_if_no_path\fR when multipathd is not running.
> -.
> -.TP
> -.B \-a
> -Add the WWID for the specified device to the WWIDs file.
> -.
> -.TP
>  .B \-u
>  Check if the device specified in the program environment should be
>  a path in a multipath device.
> @@ -147,60 +169,99 @@ Check if the device specified in the program environment is a multipath device
>  with usable paths. See \fB-C\fB.
>  .
>  .TP
> -.B \-w
> -Remove the WWID for the specified device from the WWIDs file.
> +.B \-h
> +Print usage text.
>  .
>  .TP
> -.B \-W
> -Reset the WWIDs file to only include the current multipath devices.
> +.B \-t
> +Display the currently used multipathd configuration.
>  .
>  .TP
> -.BI \-p " policy"
> -Force new maps to use the specified policy:
> +.B \-T
> +Display the currently used multipathd configuration, limiting the output to
> +those devices actually present in the system. This can be used a template for
> +creating \fImultipath.conf\fR.
> +.
> +.\" ----------------------------------------------------------------------------
> +.SH OPTIONS
> +.\" ----------------------------------------------------------------------------
> +.
> +.TP
> +.BI \-v " level"
> +Verbosity of information printed to stdout in default and "list" operation
> +modes. The default level is \fI-v 2\fR.
>  .RS 1.2i
>  .TP 1.2i
> -.I failover
> -One path per priority group.
> +.I 0
> +Nothing is printed.
>  .TP
> -.I multibus
> -All paths in one priority group.
> +.I 1
> +In default mode, Names/WWIDs of created or modified multipath maps are
> +printed. In list mode, WWIDs of all multipath maps are printed.
>  .TP
> -.I group_by_serial
> -One priority group per serial number.
> +.I 2
> +In default mode,
> +Topology of created or modified multipath maps is printed.
> +In list mode, topology of all multipath maps is printed.
>  .TP
> -.I group_by_prio
> -One priority group per priority value. Priorities are determined by
> -callout programs specified as a global, per-controller or
> -per-multipath option in the configuration file.
> +.I 3
> +All detected paths and the topology of all multipath maps are printed.
> +.
> +.LP
> +.
> +The verbosity level also controls the level of log and debug messages printed to
> +\fIstderr\fR. The default level corresponds to \fILOG_NOTICE\fR
> +(important messages that shouldn't be missed in normal operation).
> +.
> +.RE
>  .TP
> -.I group_by_node_name
> -One priority group per target node name. Target node names are fetched
> -in \fI/sys/class/fc_transport/target*/node_name\fR.
> +.B \-d
> +Dry run, do not create or update devmaps.
> +.
>  .TP
> -.RE
> -Existing maps are not modified.
> +.B \-i
> +Ignore WWIDs file when processing devices. If
> +\fIfind_multipaths strict\fR or \fIfind_multipaths no\fR is set in
> +\fImultipath.conf\fR, multipath only considers devices that are
> +listed in the WWIDs file. This option overrides that behavior. For other values
> +of \fIfind_multipaths\fR, this option has no effect. See the description of
> +\fIfind_multipaths\fR in
> +.BR multipath.conf (5).
> +This option should only be used in rare circumstances.
>  .
>  .TP
> -.BI \-R " retries"
> -Number of times to retry flushing multipath devices that are in-use. The default
> -is \fI0\fR.
> +.B \-B
> +Treat the bindings file as read only.
>  .
>  .TP
> -.BI device
> -Update only the devmap specified by
> -.IR device ,
> -which is either:
> -.RS 1.2i
> -.IP \[bu]
> -A devmap name.
> -.IP \[bu]
> -A path associated with the desired devmap; the path may be in one of the following formats:
> -.RS 1.2i
> -.IP \[bu]
> -.B /dev/sdX
> -.IP \[bu]
> -.B major:minor
> +.BI \-b " file"
> +Set \fIuser_friendly_names\fR bindings file location.  The default is
> +\fI/etc/multipath/bindings\fR.
> +.
> +.TP
> +.B \-q
> +Don't unset the device mapper feature \fIqueue_if_no_path\fR for multipath
> +maps. Normally, \fBmultipath\fR would do so if \fBmultipathd\fR is not
> +running, because only a running multipath daemon guarantees that unusable
> +paths are reinstated when they become usable again.
> +.
> +.TP
> +.BI \-p " policy"
> +Force new maps to use the specified policy, overriding the configuration in
> +\fBmultipath.conf(5)\fR. The possible values for
> +\fIpolicy\fR are the same as the values for \fIpath_grouping_policy\fR in
> +\fBmultipath.conf(5)\fR. Existing maps are not modified.
> +.
> +.TP
> +.B \-r
> +Force a reload of all existing multipath maps. This command is delegated to
> +the multipathd daemon if it's running. In this case, other command line
> +switches of the \fImultipath\fR command have no effect.
>  .
> +.TP
> +.BI \-R " retries"
> +Number of times to retry flushing multipath devices that are in use. The default
> +is \fI0\fR.
>  .
>  .\" ----------------------------------------------------------------------------
>  .SH "SEE ALSO"
> -- 
> 2.19.0
