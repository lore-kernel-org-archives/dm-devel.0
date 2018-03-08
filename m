From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: refresh kernel-doc from kernel
	sources
Date: Thu,  8 Mar 2018 20:34:40 +0100
Message-ID: <20180308193440.12937-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Gris Ge <fge@redhat.com>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Bugs fixed and "get rid of unused output formats"
b05142675310d2ac80276569e151742f880e3ec3:

Since there isn't any docbook code anymore upstream,
we can get rid of several output formats:

- docbook/xml, html, html5 and list formats were used by
  the old build system;
- As ReST is text, there's not much sense on outputting
  on a different text format.

After this patch, only man and rst output formats are
supported.

Cc: Gris Ge <fge@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libdmmp/docs/kernel-doc | 1507 +++++++----------------------------------------
 1 file changed, 218 insertions(+), 1289 deletions(-)
 mode change 100644 => 100755 libdmmp/docs/kernel-doc

diff --git a/libdmmp/docs/kernel-doc b/libdmmp/docs/kernel-doc
old mode 100644
new mode 100755
index 7bd52b8..fee8952
--- a/libdmmp/docs/kernel-doc
+++ b/libdmmp/docs/kernel-doc
@@ -48,16 +48,12 @@ Read C language source or header FILEs, extract embedded documentation comments,
 and print formatted documentation to standard output.
 
 The documentation comments are identified by "/**" opening comment mark. See
-Documentation/kernel-doc-nano-HOWTO.txt for the documentation comment syntax.
+Documentation/doc-guide/kernel-doc.rst for the documentation comment syntax.
 
 Output format selection (mutually exclusive):
-  -docbook		Output DocBook format.
-  -html			Output HTML format.
-  -html5		Output HTML5 format.
-  -list			Output symbol list format. This is for use by docproc.
   -man			Output troff manual page format. This is the default.
   -rst			Output reStructuredText format.
-  -text			Output plain text format.
+  -none			Do not output documentation, only warnings.
 
 Output selection (mutually exclusive):
   -export		Only output documentation for symbols that have been
@@ -215,7 +211,7 @@ my $anon_struct_union = 0;
 my $type_constant = '\b``([^\`]+)``\b';
 my $type_constant2 = '\%([-_\w]+)';
 my $type_func = '(\w+)\(\)';
-my $type_param = '\@(\w+(\.\.\.)?)';
+my $type_param = '\@(\w*(\.\w+)*(\.\.\.)?)';
 my $type_fp_param = '\@(\w+)\(\)';  # Special RST handling for func ptr params
 my $type_env = '(\$\w+)';
 my $type_enum = '\&(enum\s*([_\w]+))';
@@ -224,84 +220,11 @@ my $type_typedef = '\&(typedef\s*([_\w]+))';
 my $type_union = '\&(union\s*([_\w]+))';
 my $type_member = '\&([_\w]+)(\.|->)([_\w]+)';
 my $type_fallback = '\&([_\w]+)';
-my $type_enum_xml = '\&amp;(enum\s*([_\w]+))';
-my $type_struct_xml = '\&amp;(struct\s*([_\w]+))';
-my $type_typedef_xml = '\&amp;(typedef\s*([_\w]+))';
-my $type_union_xml = '\&amp;(union\s*([_\w]+))';
-my $type_member_xml = '\&amp;([_\w]+)(\.|-\&gt;)([_\w]+)';
-my $type_fallback_xml = '\&amp([_\w]+)';
 my $type_member_func = $type_member . '\(\)';
 
 # Output conversion substitutions.
 #  One for each output format
 
-# these work fairly well
-my @highlights_html = (
-                       [$type_constant, "<i>\$1</i>"],
-                       [$type_constant2, "<i>\$1</i>"],
-                       [$type_func, "<b>\$1</b>"],
-                       [$type_enum_xml, "<i>\$1</i>"],
-                       [$type_struct_xml, "<i>\$1</i>"],
-                       [$type_typedef_xml, "<i>\$1</i>"],
-                       [$type_union_xml, "<i>\$1</i>"],
-                       [$type_env, "<b><i>\$1</i></b>"],
-                       [$type_param, "<tt><b>\$1</b></tt>"],
-                       [$type_member_xml, "<tt><i>\$1</i>\$2\$3</tt>"],
-                       [$type_fallback_xml, "<i>\$1</i>"]
-                      );
-my $local_lt = "\\\\\\\\lt:";
-my $local_gt = "\\\\\\\\gt:";
-my $blankline_html = $local_lt . "p" . $local_gt;	# was "<p>"
-
-# html version 5
-my @highlights_html5 = (
-                        [$type_constant, "<span class=\"const\">\$1</span>"],
-                        [$type_constant2, "<span class=\"const\">\$1</span>"],
-                        [$type_func, "<span class=\"func\">\$1</span>"],
-                        [$type_enum_xml, "<span class=\"enum\">\$1</span>"],
-                        [$type_struct_xml, "<span class=\"struct\">\$1</span>"],
-                        [$type_typedef_xml, "<span class=\"typedef\">\$1</span>"],
-                        [$type_union_xml, "<span class=\"union\">\$1</span>"],
-                        [$type_env, "<span class=\"env\">\$1</span>"],
-                        [$type_param, "<span class=\"param\">\$1</span>]"],
-                        [$type_member_xml, "<span class=\"literal\"><span class=\"struct\">\$1</span>\$2<span class=\"member\">\$3</span></span>"],
-                        [$type_fallback_xml, "<span class=\"struct\">\$1</span>"]
-		       );
-my $blankline_html5 = $local_lt . "br /" . $local_gt;
-
-# XML, docbook format
-my @highlights_xml = (
-                      ["([^=])\\\"([^\\\"<]+)\\\"", "\$1<quote>\$2</quote>"],
-                      [$type_constant, "<constant>\$1</constant>"],
-                      [$type_constant2, "<constant>\$1</constant>"],
-                      [$type_enum_xml, "<type>\$1</type>"],
-                      [$type_struct_xml, "<structname>\$1</structname>"],
-                      [$type_typedef_xml, "<type>\$1</type>"],
-                      [$type_union_xml, "<structname>\$1</structname>"],
-                      [$type_param, "<parameter>\$1</parameter>"],
-                      [$type_func, "<function>\$1</function>"],
-                      [$type_env, "<envar>\$1</envar>"],
-                      [$type_member_xml, "<literal><structname>\$1</structname>\$2<structfield>\$3</structfield></literal>"],
-                      [$type_fallback_xml, "<structname>\$1</structname>"]
-		     );
-my $blankline_xml = $local_lt . "/para" . $local_gt . $local_lt . "para" . $local_gt . "\n";
-
-# gnome, docbook format
-my @highlights_gnome = (
-                        [$type_constant, "<replaceable class=\"option\">\$1</replaceable>"],
-                        [$type_constant2, "<replaceable class=\"option\">\$1</replaceable>"],
-                        [$type_func, "<function>\$1</function>"],
-                        [$type_enum, "<type>\$1</type>"],
-                        [$type_struct, "<structname>\$1</structname>"],
-                        [$type_typedef, "<type>\$1</type>"],
-                        [$type_union, "<structname>\$1</structname>"],
-                        [$type_env, "<envar>\$1</envar>"],
-                        [$type_param, "<parameter>\$1</parameter>" ],
-                        [$type_member, "<literal><structname>\$1</structname>\$2<structfield>\$3</structfield></literal>"],
-                        [$type_fallback, "<structname>\$1</structname>"]
-		       );
-my $blankline_gnome = "</para><para>\n";
-
 # these are pretty rough
 my @highlights_man = (
                       [$type_constant, "\$1"],
@@ -317,21 +240,6 @@ my @highlights_man = (
 		     );
 my $blankline_man = "";
 
-# text-mode
-my @highlights_text = (
-                       [$type_constant, "\$1"],
-                       [$type_constant2, "\$1"],
-                       [$type_func, "\$1"],
-                       [$type_enum, "\$1"],
-                       [$type_struct, "\$1"],
-                       [$type_typedef, "\$1"],
-                       [$type_union, "\$1"],
-                       [$type_param, "\$1"],
-                       [$type_member, "\$1\$2\$3"],
-                       [$type_fallback, "\$1"]
-		      );
-my $blankline_text = "";
-
 # rst-mode
 my @highlights_rst = (
                        [$type_constant, "``\$1``"],
@@ -351,21 +259,6 @@ my @highlights_rst = (
 		      );
 my $blankline_rst = "\n";
 
-# list mode
-my @highlights_list = (
-                       [$type_constant, "\$1"],
-                       [$type_constant2, "\$1"],
-                       [$type_func, "\$1"],
-                       [$type_enum, "\$1"],
-                       [$type_struct, "\$1"],
-                       [$type_typedef, "\$1"],
-                       [$type_union, "\$1"],
-                       [$type_param, "\$1"],
-                       [$type_member, "\$1"],
-                       [$type_fallback, "\$1"]
-		      );
-my $blankline_list = "";
-
 # read arguments
 if ($#ARGV == -1) {
     usage();
@@ -375,12 +268,12 @@ my $kernelversion;
 my $dohighlight = "";
 
 my $verbose = 0;
-my $output_mode = "man";
+my $output_mode = "rst";
 my $output_preformatted = 0;
 my $no_doc_sections = 0;
 my $enable_lineno = 0;
-my @highlights = @highlights_man;
-my $blankline = $blankline_man;
+my @highlights = @highlights_rst;
+my $blankline = $blankline_rst;
 my $modulename = "Kernel API";
 
 use constant {
@@ -498,69 +391,51 @@ my $undescribed = "-- undescribed --";
 
 reset_state();
 
-while ($ARGV[0] =~ m/^-(.*)/) {
-    my $cmd = shift @ARGV;
-    if ($cmd eq "-html") {
-	$output_mode = "html";
-	@highlights = @highlights_html;
-	$blankline = $blankline_html;
-    } elsif ($cmd eq "-html5") {
-	$output_mode = "html5";
-	@highlights = @highlights_html5;
-	$blankline = $blankline_html5;
-    } elsif ($cmd eq "-man") {
+while ($ARGV[0] =~ m/^--?(.*)/) {
+    my $cmd = $1;
+    shift @ARGV;
+    if ($cmd eq "man") {
 	$output_mode = "man";
 	@highlights = @highlights_man;
 	$blankline = $blankline_man;
-    } elsif ($cmd eq "-text") {
-	$output_mode = "text";
-	@highlights = @highlights_text;
-	$blankline = $blankline_text;
-    } elsif ($cmd eq "-rst") {
+    } elsif ($cmd eq "rst") {
 	$output_mode = "rst";
 	@highlights = @highlights_rst;
 	$blankline = $blankline_rst;
-    } elsif ($cmd eq "-docbook") {
-	$output_mode = "xml";
-	@highlights = @highlights_xml;
-	$blankline = $blankline_xml;
-    } elsif ($cmd eq "-list") {
-	$output_mode = "list";
-	@highlights = @highlights_list;
-	$blankline = $blankline_list;
-    } elsif ($cmd eq "-gnome") {
-	$output_mode = "gnome";
-	@highlights = @highlights_gnome;
-	$blankline = $blankline_gnome;
-    } elsif ($cmd eq "-module") { # not needed for XML, inherits from calling document
+    } elsif ($cmd eq "none") {
+	$output_mode = "none";
+    } elsif ($cmd eq "module") { # not needed for XML, inherits from calling document
 	$modulename = shift @ARGV;
-    } elsif ($cmd eq "-function") { # to only output specific functions
+    } elsif ($cmd eq "function") { # to only output specific functions
 	$output_selection = OUTPUT_INCLUDE;
 	$function = shift @ARGV;
 	$function_table{$function} = 1;
-    } elsif ($cmd eq "-nofunction") { # output all except specific functions
+    } elsif ($cmd eq "nofunction") { # output all except specific functions
 	$output_selection = OUTPUT_EXCLUDE;
 	$function = shift @ARGV;
 	$function_table{$function} = 1;
-    } elsif ($cmd eq "-export") { # only exported symbols
+    } elsif ($cmd eq "export") { # only exported symbols
 	$output_selection = OUTPUT_EXPORTED;
 	%function_table = ();
-    } elsif ($cmd eq "-internal") { # only non-exported symbols
+    } elsif ($cmd eq "internal") { # only non-exported symbols
 	$output_selection = OUTPUT_INTERNAL;
 	%function_table = ();
-    } elsif ($cmd eq "-export-file") {
+    } elsif ($cmd eq "export-file") {
 	my $file = shift @ARGV;
 	push(@export_file_list, $file);
-    } elsif ($cmd eq "-v") {
+    } elsif ($cmd eq "v") {
 	$verbose = 1;
-    } elsif (($cmd eq "-h") || ($cmd eq "--help")) {
+    } elsif (($cmd eq "h") || ($cmd eq "help")) {
 	usage();
-    } elsif ($cmd eq '-no-doc-sections') {
+    } elsif ($cmd eq 'no-doc-sections') {
 	    $no_doc_sections = 1;
-    } elsif ($cmd eq '-enable-lineno') {
+    } elsif ($cmd eq 'enable-lineno') {
 	    $enable_lineno = 1;
-    } elsif ($cmd eq '-show-not-found') {
+    } elsif ($cmd eq 'show-not-found') {
 	$show_not_found = 1;
+    } else {
+	# Unknown argument
+        usage();
     }
 }
 
@@ -667,22 +542,11 @@ sub output_highlight {
 #	confess "output_highlight got called with no args?\n";
 #   }
 
-    if ($output_mode eq "html" || $output_mode eq "html5" ||
-	$output_mode eq "xml") {
-	$contents = local_unescape($contents);
-	# convert data read & converted thru xml_escape() into &xyz; format:
-	$contents =~ s/\\\\\\/\&/g;
-    }
 #   print STDERR "contents b4:$contents\n";
     eval $dohighlight;
     die $@ if $@;
 #   print STDERR "contents af:$contents\n";
 
-#   strip whitespaces when generating html5
-    if ($output_mode eq "html5") {
-	$contents =~ s/^\s+//;
-	$contents =~ s/\s+$//;
-    }
     foreach $line (split "\n", $contents) {
 	if (! $output_preformatted) {
 	    $line =~ s/^\s*//;
@@ -703,817 +567,6 @@ sub output_highlight {
     }
 }
 
-# output sections in html
-sub output_section_html(%) {
-    my %args = %{$_[0]};
-    my $section;
-
-    foreach $section (@{$args{'sectionlist'}}) {
-	print "<h3>$section</h3>\n";
-	print "<blockquote>\n";
-	output_highlight($args{'sections'}{$section});
-	print "</blockquote>\n";
-    }
-}
-
-# output enum in html
-sub output_enum_html(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-    my $count;
-    print "<h2>enum " . $args{'enum'} . "</h2>\n";
-
-    print "<b>enum " . $args{'enum'} . "</b> {<br>\n";
-    $count = 0;
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print " <b>" . $parameter . "</b>";
-	if ($count != $#{$args{'parameterlist'}}) {
-	    $count++;
-	    print ",\n";
-	}
-	print "<br>";
-    }
-    print "};<br>\n";
-
-    print "<h3>Constants</h3>\n";
-    print "<dl>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "<dt><b>" . $parameter . "</b>\n";
-	print "<dd>";
-	output_highlight($args{'parameterdescs'}{$parameter});
-    }
-    print "</dl>\n";
-    output_section_html(@_);
-    print "<hr>\n";
-}
-
-# output typedef in html
-sub output_typedef_html(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-    my $count;
-    print "<h2>typedef " . $args{'typedef'} . "</h2>\n";
-
-    print "<b>typedef " . $args{'typedef'} . "</b>\n";
-    output_section_html(@_);
-    print "<hr>\n";
-}
-
-# output struct in html
-sub output_struct_html(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-
-    print "<h2>" . $args{'type'} . " " . $args{'struct'} . " - " . $args{'purpose'} . "</h2>\n";
-    print "<b>" . $args{'type'} . " " . $args{'struct'} . "</b> {<br>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	if ($parameter =~ /^#/) {
-		print "$parameter<br>\n";
-		next;
-	}
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print "&nbsp; &nbsp; <i>$1</i><b>$parameter</b>) <i>($2)</i>;<br>\n";
-	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
-	    # bitfield
-	    print "&nbsp; &nbsp; <i>$1</i> <b>$parameter</b>$2;<br>\n";
-	} else {
-	    print "&nbsp; &nbsp; <i>$type</i> <b>$parameter</b>;<br>\n";
-	}
-    }
-    print "};<br>\n";
-
-    print "<h3>Members</h3>\n";
-    print "<dl>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	($parameter =~ /^#/) && next;
-
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	print "<dt><b>" . $parameter . "</b>\n";
-	print "<dd>";
-	output_highlight($args{'parameterdescs'}{$parameter_name});
-    }
-    print "</dl>\n";
-    output_section_html(@_);
-    print "<hr>\n";
-}
-
-# output function in html
-sub output_function_html(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-
-    print "<h2>" . $args{'function'} . " - " . $args{'purpose'} . "</h2>\n";
-    print "<i>" . $args{'functiontype'} . "</i>\n";
-    print "<b>" . $args{'function'} . "</b>\n";
-    print "(";
-    $count = 0;
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print "<i>$1</i><b>$parameter</b>) <i>($2)</i>";
-	} else {
-	    print "<i>" . $type . "</i> <b>" . $parameter . "</b>";
-	}
-	if ($count != $#{$args{'parameterlist'}}) {
-	    $count++;
-	    print ",\n";
-	}
-    }
-    print ")\n";
-
-    print "<h3>Arguments</h3>\n";
-    print "<dl>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	print "<dt><b>" . $parameter . "</b>\n";
-	print "<dd>";
-	output_highlight($args{'parameterdescs'}{$parameter_name});
-    }
-    print "</dl>\n";
-    output_section_html(@_);
-    print "<hr>\n";
-}
-
-# output DOC: block header in html
-sub output_blockhead_html(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-
-    foreach $section (@{$args{'sectionlist'}}) {
-	print "<h3>$section</h3>\n";
-	print "<ul>\n";
-	output_highlight($args{'sections'}{$section});
-	print "</ul>\n";
-    }
-    print "<hr>\n";
-}
-
-# output sections in html5
-sub output_section_html5(%) {
-    my %args = %{$_[0]};
-    my $section;
-
-    foreach $section (@{$args{'sectionlist'}}) {
-	print "<section>\n";
-	print "<h1>$section</h1>\n";
-	print "<p>\n";
-	output_highlight($args{'sections'}{$section});
-	print "</p>\n";
-	print "</section>\n";
-    }
-}
-
-# output enum in html5
-sub output_enum_html5(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-    my $count;
-    my $html5id;
-
-    $html5id = $args{'enum'};
-    $html5id =~ s/[^a-zA-Z0-9\-]+/_/g;
-    print "<article class=\"enum\" id=\"enum:". $html5id . "\">";
-    print "<h1>enum " . $args{'enum'} . "</h1>\n";
-    print "<ol class=\"code\">\n";
-    print "<li>";
-    print "<span class=\"keyword\">enum</span> ";
-    print "<span class=\"identifier\">" . $args{'enum'} . "</span> {";
-    print "</li>\n";
-    $count = 0;
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "<li class=\"indent\">";
-	print "<span class=\"param\">" . $parameter . "</span>";
-	if ($count != $#{$args{'parameterlist'}}) {
-	    $count++;
-	    print ",";
-	}
-	print "</li>\n";
-    }
-    print "<li>};</li>\n";
-    print "</ol>\n";
-
-    print "<section>\n";
-    print "<h1>Constants</h1>\n";
-    print "<dl>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "<dt>" . $parameter . "</dt>\n";
-	print "<dd>";
-	output_highlight($args{'parameterdescs'}{$parameter});
-	print "</dd>\n";
-    }
-    print "</dl>\n";
-    print "</section>\n";
-    output_section_html5(@_);
-    print "</article>\n";
-}
-
-# output typedef in html5
-sub output_typedef_html5(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-    my $count;
-    my $html5id;
-
-    $html5id = $args{'typedef'};
-    $html5id =~ s/[^a-zA-Z0-9\-]+/_/g;
-    print "<article class=\"typedef\" id=\"typedef:" . $html5id . "\">\n";
-    print "<h1>typedef " . $args{'typedef'} . "</h1>\n";
-
-    print "<ol class=\"code\">\n";
-    print "<li>";
-    print "<span class=\"keyword\">typedef</span> ";
-    print "<span class=\"identifier\">" . $args{'typedef'} . "</span>";
-    print "</li>\n";
-    print "</ol>\n";
-    output_section_html5(@_);
-    print "</article>\n";
-}
-
-# output struct in html5
-sub output_struct_html5(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-    my $html5id;
-
-    $html5id = $args{'struct'};
-    $html5id =~ s/[^a-zA-Z0-9\-]+/_/g;
-    print "<article class=\"struct\" id=\"struct:" . $html5id . "\">\n";
-    print "<hgroup>\n";
-    print "<h1>" . $args{'type'} . " " . $args{'struct'} . "</h1>";
-    print "<h2>". $args{'purpose'} . "</h2>\n";
-    print "</hgroup>\n";
-    print "<ol class=\"code\">\n";
-    print "<li>";
-    print "<span class=\"type\">" . $args{'type'} . "</span> ";
-    print "<span class=\"identifier\">" . $args{'struct'} . "</span> {";
-    print "</li>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "<li class=\"indent\">";
-	if ($parameter =~ /^#/) {
-		print "<span class=\"param\">" . $parameter ."</span>\n";
-		print "</li>\n";
-		next;
-	}
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print "<span class=\"type\">$1</span> ";
-	    print "<span class=\"param\">$parameter</span>";
-	    print "<span class=\"type\">)</span> ";
-	    print "(<span class=\"args\">$2</span>);";
-	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
-	    # bitfield
-	    print "<span class=\"type\">$1</span> ";
-	    print "<span class=\"param\">$parameter</span>";
-	    print "<span class=\"bits\">$2</span>;";
-	} else {
-	    print "<span class=\"type\">$type</span> ";
-	    print "<span class=\"param\">$parameter</span>;";
-	}
-	print "</li>\n";
-    }
-    print "<li>};</li>\n";
-    print "</ol>\n";
-
-    print "<section>\n";
-    print "<h1>Members</h1>\n";
-    print "<dl>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	($parameter =~ /^#/) && next;
-
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	print "<dt>" . $parameter . "</dt>\n";
-	print "<dd>";
-	output_highlight($args{'parameterdescs'}{$parameter_name});
-	print "</dd>\n";
-    }
-    print "</dl>\n";
-    print "</section>\n";
-    output_section_html5(@_);
-    print "</article>\n";
-}
-
-# output function in html5
-sub output_function_html5(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-    my $html5id;
-
-    $html5id = $args{'function'};
-    $html5id =~ s/[^a-zA-Z0-9\-]+/_/g;
-    print "<article class=\"function\" id=\"func:". $html5id . "\">\n";
-    print "<hgroup>\n";
-    print "<h1>" . $args{'function'} . "</h1>";
-    print "<h2>" . $args{'purpose'} . "</h2>\n";
-    print "</hgroup>\n";
-    print "<ol class=\"code\">\n";
-    print "<li>";
-    print "<span class=\"type\">" . $args{'functiontype'} . "</span> ";
-    print "<span class=\"identifier\">" . $args{'function'} . "</span> (";
-    print "</li>";
-    $count = 0;
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "<li class=\"indent\">";
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print "<span class=\"type\">$1</span> ";
-	    print "<span class=\"param\">$parameter</span>";
-	    print "<span class=\"type\">)</span> ";
-	    print "(<span class=\"args\">$2</span>)";
-	} else {
-	    print "<span class=\"type\">$type</span> ";
-	    print "<span class=\"param\">$parameter</span>";
-	}
-	if ($count != $#{$args{'parameterlist'}}) {
-	    $count++;
-	    print ",";
-	}
-	print "</li>\n";
-    }
-    print "<li>)</li>\n";
-    print "</ol>\n";
-
-    print "<section>\n";
-    print "<h1>Arguments</h1>\n";
-    print "<p>\n";
-    print "<dl>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	print "<dt>" . $parameter . "</dt>\n";
-	print "<dd>";
-	output_highlight($args{'parameterdescs'}{$parameter_name});
-	print "</dd>\n";
-    }
-    print "</dl>\n";
-    print "</section>\n";
-    output_section_html5(@_);
-    print "</article>\n";
-}
-
-# output DOC: block header in html5
-sub output_blockhead_html5(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-    my $html5id;
-
-    foreach $section (@{$args{'sectionlist'}}) {
-	$html5id = $section;
-	$html5id =~ s/[^a-zA-Z0-9\-]+/_/g;
-	print "<article class=\"doc\" id=\"doc:". $html5id . "\">\n";
-	print "<h1>$section</h1>\n";
-	print "<p>\n";
-	output_highlight($args{'sections'}{$section});
-	print "</p>\n";
-    }
-    print "</article>\n";
-}
-
-sub output_section_xml(%) {
-    my %args = %{$_[0]};
-    my $section;
-    # print out each section
-    $lineprefix="   ";
-    foreach $section (@{$args{'sectionlist'}}) {
-	print "<refsect1>\n";
-	print "<title>$section</title>\n";
-	if ($section =~ m/EXAMPLE/i) {
-	    print "<informalexample><programlisting>\n";
-	    $output_preformatted = 1;
-	} else {
-	    print "<para>\n";
-	}
-	output_highlight($args{'sections'}{$section});
-	$output_preformatted = 0;
-	if ($section =~ m/EXAMPLE/i) {
-	    print "</programlisting></informalexample>\n";
-	} else {
-	    print "</para>\n";
-	}
-	print "</refsect1>\n";
-    }
-}
-
-# output function in XML DocBook
-sub output_function_xml(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-    my $id;
-
-    $id = "API-" . $args{'function'};
-    $id =~ s/[^A-Za-z0-9]/-/g;
-
-    print "<refentry id=\"$id\">\n";
-    print "<refentryinfo>\n";
-    print " <title>LINUX</title>\n";
-    print " <productname>Kernel Hackers Manual</productname>\n";
-    print " <date>$man_date</date>\n";
-    print "</refentryinfo>\n";
-    print "<refmeta>\n";
-    print " <refentrytitle><phrase>" . $args{'function'} . "</phrase></refentrytitle>\n";
-    print " <manvolnum>9</manvolnum>\n";
-    print " <refmiscinfo class=\"version\">" . $kernelversion . "</refmiscinfo>\n";
-    print "</refmeta>\n";
-    print "<refnamediv>\n";
-    print " <refname>" . $args{'function'} . "</refname>\n";
-    print " <refpurpose>\n";
-    print "  ";
-    output_highlight ($args{'purpose'});
-    print " </refpurpose>\n";
-    print "</refnamediv>\n";
-
-    print "<refsynopsisdiv>\n";
-    print " <title>Synopsis</title>\n";
-    print "  <funcsynopsis><funcprototype>\n";
-    print "   <funcdef>" . $args{'functiontype'} . " ";
-    print "<function>" . $args{'function'} . " </function></funcdef>\n";
-
-    $count = 0;
-    if ($#{$args{'parameterlist'}} >= 0) {
-	foreach $parameter (@{$args{'parameterlist'}}) {
-	    $type = $args{'parametertypes'}{$parameter};
-	    if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-		# pointer-to-function
-		print "   <paramdef>$1<parameter>$parameter</parameter>)\n";
-		print "     <funcparams>$2</funcparams></paramdef>\n";
-	    } else {
-		print "   <paramdef>" . $type;
-		print " <parameter>$parameter</parameter></paramdef>\n";
-	    }
-	}
-    } else {
-	print "  <void/>\n";
-    }
-    print "  </funcprototype></funcsynopsis>\n";
-    print "</refsynopsisdiv>\n";
-
-    # print parameters
-    print "<refsect1>\n <title>Arguments</title>\n";
-    if ($#{$args{'parameterlist'}} >= 0) {
-	print " <variablelist>\n";
-	foreach $parameter (@{$args{'parameterlist'}}) {
-	    my $parameter_name = $parameter;
-	    $parameter_name =~ s/\[.*//;
-	    $type = $args{'parametertypes'}{$parameter};
-
-	    print "  <varlistentry>\n   <term><parameter>$type $parameter</parameter></term>\n";
-	    print "   <listitem>\n    <para>\n";
-	    $lineprefix="     ";
-	    output_highlight($args{'parameterdescs'}{$parameter_name});
-	    print "    </para>\n   </listitem>\n  </varlistentry>\n";
-	}
-	print " </variablelist>\n";
-    } else {
-	print " <para>\n  None\n </para>\n";
-    }
-    print "</refsect1>\n";
-
-    output_section_xml(@_);
-    print "</refentry>\n\n";
-}
-
-# output struct in XML DocBook
-sub output_struct_xml(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $id;
-
-    $id = "API-struct-" . $args{'struct'};
-    $id =~ s/[^A-Za-z0-9]/-/g;
-
-    print "<refentry id=\"$id\">\n";
-    print "<refentryinfo>\n";
-    print " <title>LINUX</title>\n";
-    print " <productname>Kernel Hackers Manual</productname>\n";
-    print " <date>$man_date</date>\n";
-    print "</refentryinfo>\n";
-    print "<refmeta>\n";
-    print " <refentrytitle><phrase>" . $args{'type'} . " " . $args{'struct'} . "</phrase></refentrytitle>\n";
-    print " <manvolnum>9</manvolnum>\n";
-    print " <refmiscinfo class=\"version\">" . $kernelversion . "</refmiscinfo>\n";
-    print "</refmeta>\n";
-    print "<refnamediv>\n";
-    print " <refname>" . $args{'type'} . " " . $args{'struct'} . "</refname>\n";
-    print " <refpurpose>\n";
-    print "  ";
-    output_highlight ($args{'purpose'});
-    print " </refpurpose>\n";
-    print "</refnamediv>\n";
-
-    print "<refsynopsisdiv>\n";
-    print " <title>Synopsis</title>\n";
-    print "  <programlisting>\n";
-    print $args{'type'} . " " . $args{'struct'} . " {\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	if ($parameter =~ /^#/) {
-	    my $prm = $parameter;
-	    # convert data read & converted thru xml_escape() into &xyz; format:
-	    # This allows us to have #define macros interspersed in a struct.
-	    $prm =~ s/\\\\\\/\&/g;
-	    print "$prm\n";
-	    next;
-	}
-
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	defined($args{'parameterdescs'}{$parameter_name}) || next;
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print "  $1 $parameter) ($2);\n";
-	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
-	    # bitfield
-	    print "  $1 $parameter$2;\n";
-	} else {
-	    print "  " . $type . " " . $parameter . ";\n";
-	}
-    }
-    print "};";
-    print "  </programlisting>\n";
-    print "</refsynopsisdiv>\n";
-
-    print " <refsect1>\n";
-    print "  <title>Members</title>\n";
-
-    if ($#{$args{'parameterlist'}} >= 0) {
-    print "  <variablelist>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-      ($parameter =~ /^#/) && next;
-
-      my $parameter_name = $parameter;
-      $parameter_name =~ s/\[.*//;
-
-      defined($args{'parameterdescs'}{$parameter_name}) || next;
-      ($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-      $type = $args{'parametertypes'}{$parameter};
-      print "    <varlistentry>";
-      print "      <term><literal>$type $parameter</literal></term>\n";
-      print "      <listitem><para>\n";
-      output_highlight($args{'parameterdescs'}{$parameter_name});
-      print "      </para></listitem>\n";
-      print "    </varlistentry>\n";
-    }
-    print "  </variablelist>\n";
-    } else {
-	print " <para>\n  None\n </para>\n";
-    }
-    print " </refsect1>\n";
-
-    output_section_xml(@_);
-
-    print "</refentry>\n\n";
-}
-
-# output enum in XML DocBook
-sub output_enum_xml(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-    my $id;
-
-    $id = "API-enum-" . $args{'enum'};
-    $id =~ s/[^A-Za-z0-9]/-/g;
-
-    print "<refentry id=\"$id\">\n";
-    print "<refentryinfo>\n";
-    print " <title>LINUX</title>\n";
-    print " <productname>Kernel Hackers Manual</productname>\n";
-    print " <date>$man_date</date>\n";
-    print "</refentryinfo>\n";
-    print "<refmeta>\n";
-    print " <refentrytitle><phrase>enum " . $args{'enum'} . "</phrase></refentrytitle>\n";
-    print " <manvolnum>9</manvolnum>\n";
-    print " <refmiscinfo class=\"version\">" . $kernelversion . "</refmiscinfo>\n";
-    print "</refmeta>\n";
-    print "<refnamediv>\n";
-    print " <refname>enum " . $args{'enum'} . "</refname>\n";
-    print " <refpurpose>\n";
-    print "  ";
-    output_highlight ($args{'purpose'});
-    print " </refpurpose>\n";
-    print "</refnamediv>\n";
-
-    print "<refsynopsisdiv>\n";
-    print " <title>Synopsis</title>\n";
-    print "  <programlisting>\n";
-    print "enum " . $args{'enum'} . " {\n";
-    $count = 0;
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "  $parameter";
-	if ($count != $#{$args{'parameterlist'}}) {
-	    $count++;
-	    print ",";
-	}
-	print "\n";
-    }
-    print "};";
-    print "  </programlisting>\n";
-    print "</refsynopsisdiv>\n";
-
-    print "<refsect1>\n";
-    print " <title>Constants</title>\n";
-    print "  <variablelist>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-      my $parameter_name = $parameter;
-      $parameter_name =~ s/\[.*//;
-
-      print "    <varlistentry>";
-      print "      <term>$parameter</term>\n";
-      print "      <listitem><para>\n";
-      output_highlight($args{'parameterdescs'}{$parameter_name});
-      print "      </para></listitem>\n";
-      print "    </varlistentry>\n";
-    }
-    print "  </variablelist>\n";
-    print "</refsect1>\n";
-
-    output_section_xml(@_);
-
-    print "</refentry>\n\n";
-}
-
-# output typedef in XML DocBook
-sub output_typedef_xml(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $id;
-
-    $id = "API-typedef-" . $args{'typedef'};
-    $id =~ s/[^A-Za-z0-9]/-/g;
-
-    print "<refentry id=\"$id\">\n";
-    print "<refentryinfo>\n";
-    print " <title>LINUX</title>\n";
-    print " <productname>Kernel Hackers Manual</productname>\n";
-    print " <date>$man_date</date>\n";
-    print "</refentryinfo>\n";
-    print "<refmeta>\n";
-    print " <refentrytitle><phrase>typedef " . $args{'typedef'} . "</phrase></refentrytitle>\n";
-    print " <manvolnum>9</manvolnum>\n";
-    print "</refmeta>\n";
-    print "<refnamediv>\n";
-    print " <refname>typedef " . $args{'typedef'} . "</refname>\n";
-    print " <refpurpose>\n";
-    print "  ";
-    output_highlight ($args{'purpose'});
-    print " </refpurpose>\n";
-    print "</refnamediv>\n";
-
-    print "<refsynopsisdiv>\n";
-    print " <title>Synopsis</title>\n";
-    print "  <synopsis>typedef " . $args{'typedef'} . ";</synopsis>\n";
-    print "</refsynopsisdiv>\n";
-
-    output_section_xml(@_);
-
-    print "</refentry>\n\n";
-}
-
-# output in XML DocBook
-sub output_blockhead_xml(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-
-    my $id = $args{'module'};
-    $id =~ s/[^A-Za-z0-9]/-/g;
-
-    # print out each section
-    $lineprefix="   ";
-    foreach $section (@{$args{'sectionlist'}}) {
-	if (!$args{'content-only'}) {
-		print "<refsect1>\n <title>$section</title>\n";
-	}
-	if ($section =~ m/EXAMPLE/i) {
-	    print "<example><para>\n";
-	    $output_preformatted = 1;
-	} else {
-	    print "<para>\n";
-	}
-	output_highlight($args{'sections'}{$section});
-	$output_preformatted = 0;
-	if ($section =~ m/EXAMPLE/i) {
-	    print "</para></example>\n";
-	} else {
-	    print "</para>";
-	}
-	if (!$args{'content-only'}) {
-		print "\n</refsect1>\n";
-	}
-    }
-
-    print "\n\n";
-}
-
-# output in XML DocBook
-sub output_function_gnome {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-    my $id;
-
-    $id = $args{'module'} . "-" . $args{'function'};
-    $id =~ s/[^A-Za-z0-9]/-/g;
-
-    print "<sect2>\n";
-    print " <title id=\"$id\">" . $args{'function'} . "</title>\n";
-
-    print "  <funcsynopsis>\n";
-    print "   <funcdef>" . $args{'functiontype'} . " ";
-    print "<function>" . $args{'function'} . " ";
-    print "</function></funcdef>\n";
-
-    $count = 0;
-    if ($#{$args{'parameterlist'}} >= 0) {
-	foreach $parameter (@{$args{'parameterlist'}}) {
-	    $type = $args{'parametertypes'}{$parameter};
-	    if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-		# pointer-to-function
-		print "   <paramdef>$1 <parameter>$parameter</parameter>)\n";
-		print "     <funcparams>$2</funcparams></paramdef>\n";
-	    } else {
-		print "   <paramdef>" . $type;
-		print " <parameter>$parameter</parameter></paramdef>\n";
-	    }
-	}
-    } else {
-	print "  <void>\n";
-    }
-    print "  </funcsynopsis>\n";
-    if ($#{$args{'parameterlist'}} >= 0) {
-	print " <informaltable pgwide=\"1\" frame=\"none\" role=\"params\">\n";
-	print "<tgroup cols=\"2\">\n";
-	print "<colspec colwidth=\"2*\">\n";
-	print "<colspec colwidth=\"8*\">\n";
-	print "<tbody>\n";
-	foreach $parameter (@{$args{'parameterlist'}}) {
-	    my $parameter_name = $parameter;
-	    $parameter_name =~ s/\[.*//;
-
-	    print "  <row><entry align=\"right\"><parameter>$parameter</parameter></entry>\n";
-	    print "   <entry>\n";
-	    $lineprefix="     ";
-	    output_highlight($args{'parameterdescs'}{$parameter_name});
-	    print "    </entry></row>\n";
-	}
-	print " </tbody></tgroup></informaltable>\n";
-    } else {
-	print " <para>\n  None\n </para>\n";
-    }
-
-    # print out each section
-    $lineprefix="   ";
-    foreach $section (@{$args{'sectionlist'}}) {
-	print "<simplesect>\n <title>$section</title>\n";
-	if ($section =~ m/EXAMPLE/i) {
-	    print "<example><programlisting>\n";
-	    $output_preformatted = 1;
-	} else {
-	}
-	print "<para>\n";
-	output_highlight($args{'sections'}{$section});
-	$output_preformatted = 0;
-	print "</para>\n";
-	if ($section =~ m/EXAMPLE/i) {
-	    print "</programlisting></example>\n";
-	} else {
-	}
-	print " </simplesect>\n";
-    }
-
-    print "</sect2>\n\n";
-}
-
 ##
 # output function in man
 sub output_function_man(%) {
@@ -1617,32 +670,12 @@ sub output_struct_man(%) {
     print ".SH NAME\n";
     print $args{'type'} . " " . $args{'struct'} . " \\- " . $args{'purpose'} . "\n";
 
+    my $declaration = $args{'definition'};
+    $declaration =~ s/\t/  /g;
+    $declaration =~ s/\n/"\n.br\n.BI \"/g;
     print ".SH SYNOPSIS\n";
     print $args{'type'} . " " . $args{'struct'} . " {\n.br\n";
-
-    foreach my $parameter (@{$args{'parameterlist'}}) {
-	if ($parameter =~ /^#/) {
-	    print ".BI \"$parameter\"\n.br\n";
-	    next;
-	}
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print ".BI \"    " . $1 . "\" " . $parameter . " \") (" . $2 . ")" . "\"\n;\n";
-	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
-	    # bitfield
-	    print ".BI \"    " . $1 . "\ \" " . $parameter . $2 . " \"" . "\"\n;\n";
-	} else {
-	    $type =~ s/([^\*])$/$1 /;
-	    print ".BI \"    " . $type . "\" " . $parameter . " \"" . "\"\n;\n";
-	}
-	print "\n.br\n";
-    }
-    print "};\n.br\n";
+    print ".BI \"$declaration\n};\n.br\n\n";
 
     print ".SH Members\n";
     foreach $parameter (@{$args{'parameterlist'}}) {
@@ -1691,161 +724,6 @@ sub output_blockhead_man(%) {
     }
 }
 
-##
-# output in text
-sub output_function_text(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $start;
-
-    print "Name:\n\n";
-    print $args{'function'} . " - " . $args{'purpose'} . "\n";
-
-    print "\nSynopsis:\n\n";
-    if ($args{'functiontype'} ne "") {
-	$start = $args{'functiontype'} . " " . $args{'function'} . " (";
-    } else {
-	$start = $args{'function'} . " (";
-    }
-    print $start;
-
-    my $count = 0;
-    foreach my $parameter (@{$args{'parameterlist'}}) {
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print $1 . $parameter . ") (" . $2;
-	} else {
-	    print $type . " " . $parameter;
-	}
-	if ($count != $#{$args{'parameterlist'}}) {
-	    $count++;
-	    print ",\n";
-	    print " " x length($start);
-	} else {
-	    print ");\n\n";
-	}
-    }
-
-    print "Arguments:\n\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	print $parameter . "\n\t" . $args{'parameterdescs'}{$parameter_name} . "\n";
-    }
-    output_section_text(@_);
-}
-
-#output sections in text
-sub output_section_text(%) {
-    my %args = %{$_[0]};
-    my $section;
-
-    print "\n";
-    foreach $section (@{$args{'sectionlist'}}) {
-	print "$section:\n\n";
-	output_highlight($args{'sections'}{$section});
-    }
-    print "\n\n";
-}
-
-# output enum in text
-sub output_enum_text(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-    my $count;
-    print "Enum:\n\n";
-
-    print "enum " . $args{'enum'} . " - " . $args{'purpose'} . "\n\n";
-    print "enum " . $args{'enum'} . " {\n";
-    $count = 0;
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "\t$parameter";
-	if ($count != $#{$args{'parameterlist'}}) {
-	    $count++;
-	    print ",";
-	}
-	print "\n";
-    }
-    print "};\n\n";
-
-    print "Constants:\n\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "$parameter\n\t";
-	print $args{'parameterdescs'}{$parameter} . "\n";
-    }
-
-    output_section_text(@_);
-}
-
-# output typedef in text
-sub output_typedef_text(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-    my $count;
-    print "Typedef:\n\n";
-
-    print "typedef " . $args{'typedef'} . " - " . $args{'purpose'} . "\n";
-    output_section_text(@_);
-}
-
-# output struct as text
-sub output_struct_text(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-
-    print $args{'type'} . " " . $args{'struct'} . " - " . $args{'purpose'} . "\n\n";
-    print $args{'type'} . " " . $args{'struct'} . " {\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	if ($parameter =~ /^#/) {
-	    print "$parameter\n";
-	    next;
-	}
-
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print "\t$1 $parameter) ($2);\n";
-	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
-	    # bitfield
-	    print "\t$1 $parameter$2;\n";
-	} else {
-	    print "\t" . $type . " " . $parameter . ";\n";
-	}
-    }
-    print "};\n\n";
-
-    print "Members:\n\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	($parameter =~ /^#/) && next;
-
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	print "$parameter\n\t";
-	print $args{'parameterdescs'}{$parameter_name} . "\n";
-    }
-    print "\n";
-    output_section_text(@_);
-}
-
-sub output_blockhead_text(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-
-    foreach $section (@{$args{'sectionlist'}}) {
-	print " $section:\n";
-	print "    -> ";
-	output_highlight($args{'sections'}{$section});
-    }
-}
-
 ##
 # output in restructured text
 #
@@ -2035,29 +913,9 @@ sub output_struct_rst(%) {
 
     print "**Definition**\n\n";
     print "::\n\n";
-    print "  " . $args{'type'} . " " . $args{'struct'} . " {\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	if ($parameter =~ /^#/) {
-	    print "  " . "$parameter\n";
-	    next;
-	}
-
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print "    $1 $parameter) ($2);\n";
-	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
-	    # bitfield
-	    print "    $1 $parameter$2;\n";
-	} else {
-	    print "    " . $type . " " . $parameter . ";\n";
-	}
-    }
-    print "  };\n\n";
+    my $declaration = $args{'definition'};
+    $declaration =~ s/\t/  /g;
+    print "  " . $args{'type'} . " " . $args{'struct'} . " {\n$declaration  };\n\n";
 
     print "**Members**\n\n";
     $lineprefix = "  ";
@@ -2080,41 +938,21 @@ sub output_struct_rst(%) {
     output_section_rst(@_);
 }
 
+## none mode output functions
 
-## list mode output functions
-
-sub output_function_list(%) {
-    my %args = %{$_[0]};
-
-    print $args{'function'} . "\n";
+sub output_function_none(%) {
 }
 
-# output enum in list
-sub output_enum_list(%) {
-    my %args = %{$_[0]};
-    print $args{'enum'} . "\n";
+sub output_enum_none(%) {
 }
 
-# output typedef in list
-sub output_typedef_list(%) {
-    my %args = %{$_[0]};
-    print $args{'typedef'} . "\n";
+sub output_typedef_none(%) {
 }
 
-# output struct as list
-sub output_struct_list(%) {
-    my %args = %{$_[0]};
-
-    print $args{'struct'} . "\n";
+sub output_struct_none(%) {
 }
 
-sub output_blockhead_list(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-
-    foreach $section (@{$args{'sectionlist'}}) {
-	print "DOC: $section\n";
-    }
+sub output_blockhead_none(%) {
 }
 
 ##
@@ -2165,39 +1003,128 @@ sub dump_union($$) {
 sub dump_struct($$) {
     my $x = shift;
     my $file = shift;
-    my $nested;
 
     if ($x =~ /(struct|union)\s+(\w+)\s*{(.*)}/) {
 	my $decl_type = $1;
 	$declaration_name = $2;
 	my $members = $3;
 
-	# ignore embedded structs or unions
-	$members =~ s/({.*})//g;
-	$nested = $1;
-
 	# ignore members marked private:
 	$members =~ s/\/\*\s*private:.*?\/\*\s*public:.*?\*\///gosi;
 	$members =~ s/\/\*\s*private:.*//gosi;
 	# strip comments:
 	$members =~ s/\/\*.*?\*\///gos;
-	$nested =~ s/\/\*.*?\*\///gos;
 	# strip attributes
 	$members =~ s/__attribute__\s*\(\([a-z,_\*\s\(\)]*\)\)//i;
 	$members =~ s/__aligned\s*\([^;]*\)//gos;
 	$members =~ s/\s*CRYPTO_MINALIGN_ATTR//gos;
 	# replace DECLARE_BITMAP
-	$members =~ s/DECLARE_BITMAP\s*\(([^,)]+), ([^,)]+)\)/unsigned long $1\[BITS_TO_LONGS($2)\]/gos;
+	$members =~ s/DECLARE_BITMAP\s*\(([^,)]+),\s*([^,)]+)\)/unsigned long $1\[BITS_TO_LONGS($2)\]/gos;
 	# replace DECLARE_HASHTABLE
-	$members =~ s/DECLARE_HASHTABLE\s*\(([^,)]+), ([^,)]+)\)/unsigned long $1\[1 << (($2) - 1)\]/gos;
-
-	create_parameterlist($members, ';', $file);
-	check_sections($file, $declaration_name, $decl_type, $sectcheck, $struct_actual, $nested);
-
+	$members =~ s/DECLARE_HASHTABLE\s*\(([^,)]+),\s*([^,)]+)\)/unsigned long $1\[1 << (($2) - 1)\]/gos;
+	# replace DECLARE_KFIFO
+	$members =~ s/DECLARE_KFIFO\s*\(([^,)]+),\s*([^,)]+),\s*([^,)]+)\)/$2 \*$1/gos;
+	# replace DECLARE_KFIFO_PTR
+	$members =~ s/DECLARE_KFIFO_PTR\s*\(([^,)]+),\s*([^,)]+)\)/$2 \*$1/gos;
+
+	my $declaration = $members;
+
+	# Split nested struct/union elements as newer ones
+	while ($members =~ m/(struct|union)([^\{\};]+)\{([^\{\}]*)\}([^\{\}\;]*)\;/) {
+		my $newmember;
+		my $maintype = $1;
+		my $ids = $4;
+		my $content = $3;
+		foreach my $id(split /,/, $ids) {
+			$newmember .= "$maintype $id; ";
+
+			$id =~ s/[:\[].*//;
+			$id =~ s/^\s*\**(\S+)\s*/$1/;
+			foreach my $arg (split /;/, $content) {
+				next if ($arg =~ m/^\s*$/);
+				if ($arg =~ m/^([^\(]+\(\*?\s*)([\w\.]*)(\s*\).*)/) {
+					# pointer-to-function
+					my $type = $1;
+					my $name = $2;
+					my $extra = $3;
+					next if (!$name);
+					if ($id =~ m/^\s*$/) {
+						# anonymous struct/union
+						$newmember .= "$type$name$extra; ";
+					} else {
+						$newmember .= "$type$id.$name$extra; ";
+					}
+				} else {
+					my $type;
+					my $names;
+					$arg =~ s/^\s+//;
+					$arg =~ s/\s+$//;
+					# Handle bitmaps
+					$arg =~ s/:\s*\d+\s*//g;
+					# Handle arrays
+					$arg =~ s/\[\S+\]//g;
+					# The type may have multiple words,
+					# and multiple IDs can be defined, like:
+					#	const struct foo, *bar, foobar
+					# So, we remove spaces when parsing the
+					# names, in order to match just names
+					# and commas for the names
+					$arg =~ s/\s*,\s*/,/g;
+					if ($arg =~ m/(.*)\s+([\S+,]+)/) {
+						$type = $1;
+						$names = $2;
+					} else {
+						$newmember .= "$arg; ";
+						next;
+					}
+					foreach my $name (split /,/, $names) {
+						$name =~ s/^\s*\**(\S+)\s*/$1/;
+						next if (($name =~ m/^\s*$/));
+						if ($id =~ m/^\s*$/) {
+							# anonymous struct/union
+							$newmember .= "$type $name; ";
+						} else {
+							$newmember .= "$type $id.$name; ";
+						}
+					}
+				}
+			}
+		}
+		$members =~ s/(struct|union)([^\{\};]+)\{([^\{\}]*)}([^\{\}\;]*)\;/$newmember/;
+	}
+
+	# Ignore other nested elements, like enums
+	$members =~ s/({[^\{\}]*})//g;
+
+	create_parameterlist($members, ';', $file, $declaration_name);
+	check_sections($file, $declaration_name, $decl_type, $sectcheck, $struct_actual);
+
+	# Adjust declaration for better display
+	$declaration =~ s/([{;])/$1\n/g;
+	$declaration =~ s/}\s+;/};/g;
+	# Better handle inlined enums
+	do {} while ($declaration =~ s/(enum\s+{[^}]+),([^\n])/$1,\n$2/);
+
+	my @def_args = split /\n/, $declaration;
+	my $level = 1;
+	$declaration = "";
+	foreach my $clause (@def_args) {
+		$clause =~ s/^\s+//;
+		$clause =~ s/\s+$//;
+		$clause =~ s/\s+/ /;
+		next if (!$clause);
+		$level-- if ($clause =~ m/(})/ && $level > 1);
+		if (!($clause =~ m/^\s*#/)) {
+			$declaration .= "\t" x $level;
+		}
+		$declaration .= "\t" . $clause . "\n";
+		$level++ if ($clause =~ m/({)/ && !($clause =~m/}/));
+	}
 	output_declaration($declaration_name,
 			   'struct',
 			   {'struct' => $declaration_name,
 			    'module' => $modulename,
+			    'definition' => $declaration,
 			    'parameterlist' => \@parameterlist,
 			    'parameterdescs' => \%parameterdescs,
 			    'parametertypes' => \%parametertypes,
@@ -2213,6 +1140,44 @@ sub dump_struct($$) {
     }
 }
 
+
+sub show_warnings($$) {
+	my $functype = shift;
+	my $name = shift;
+
+	return 1 if ($output_selection == OUTPUT_ALL);
+
+	if ($output_selection == OUTPUT_EXPORTED) {
+		if (defined($function_table{$name})) {
+			return 1;
+		} else {
+			return 0;
+		}
+	}
+        if ($output_selection == OUTPUT_INTERNAL) {
+		if (!($functype eq "function" && defined($function_table{$name}))) {
+			return 1;
+		} else {
+			return 0;
+		}
+	}
+	if ($output_selection == OUTPUT_INCLUDE) {
+		if (defined($function_table{$name})) {
+			return 1;
+		} else {
+			return 0;
+		}
+	}
+	if ($output_selection == OUTPUT_EXCLUDE) {
+		if (!defined($function_table{$name})) {
+			return 1;
+		} else {
+			return 0;
+		}
+	}
+	die("Please add the new output type at show_warnings()");
+}
+
 sub dump_enum($$) {
     my $x = shift;
     my $file = shift;
@@ -2233,16 +1198,18 @@ sub dump_enum($$) {
 	    push @parameterlist, $arg;
 	    if (!$parameterdescs{$arg}) {
 		$parameterdescs{$arg} = $undescribed;
-		print STDERR "${file}:$.: warning: Enum value '$arg' ".
-		    "not described in enum '$declaration_name'\n";
+	        if (show_warnings("enum", $declaration_name)) {
+			print STDERR "${file}:$.: warning: Enum value '$arg' not described in enum '$declaration_name'\n";
+		}
 	    }
 	    $_members{$arg} = 1;
 	}
 
 	while (my ($k, $v) = each %parameterdescs) {
 	    if (!exists($_members{$k})) {
-	     print STDERR "${file}:$.: warning: Excess enum value " .
-	                  "'$k' description in '$declaration_name'\n";
+	        if (show_warnings("enum", $declaration_name)) {
+		     print STDERR "${file}:$.: warning: Excess enum value '$k' description in '$declaration_name'\n";
+		}
 	    }
         }
 
@@ -2278,7 +1245,7 @@ sub dump_typedef($$) {
 	$declaration_name = $2;
 	my $args = $3;
 
-	create_parameterlist($args, ',', $file);
+	create_parameterlist($args, ',', $file, $declaration_name);
 
 	output_declaration($declaration_name,
 			   'function',
@@ -2327,10 +1294,11 @@ sub save_struct_actual($) {
     $struct_actual = $struct_actual . $actual . " ";
 }
 
-sub create_parameterlist($$$) {
+sub create_parameterlist($$$$) {
     my $args = shift;
     my $splitter = shift;
     my $file = shift;
+    my $declaration_name = shift;
     my $type;
     my $param;
 
@@ -2355,12 +1323,12 @@ sub create_parameterlist($$$) {
 	} elsif ($arg =~ m/\(.+\)\s*\(/) {
 	    # pointer-to-function
 	    $arg =~ tr/#/,/;
-	    $arg =~ m/[^\(]+\(\*?\s*(\w*)\s*\)/;
+	    $arg =~ m/[^\(]+\(\*?\s*([\w\.]*)\s*\)/;
 	    $param = $1;
 	    $type = $arg;
 	    $type =~ s/([^\(]+\(\*?)\s*$param/$1/;
 	    save_struct_actual($param);
-	    push_parameter($param, $type, $file);
+	    push_parameter($param, $type, $file, $declaration_name);
 	} elsif ($arg) {
 	    $arg =~ s/\s*:\s*/:/g;
 	    $arg =~ s/\s*\[/\[/g;
@@ -2385,27 +1353,28 @@ sub create_parameterlist($$$) {
 	    foreach $param (@args) {
 		if ($param =~ m/^(\*+)\s*(.*)/) {
 		    save_struct_actual($2);
-		    push_parameter($2, "$type $1", $file);
+		    push_parameter($2, "$type $1", $file, $declaration_name);
 		}
 		elsif ($param =~ m/(.*?):(\d+)/) {
 		    if ($type ne "") { # skip unnamed bit-fields
 			save_struct_actual($1);
-			push_parameter($1, "$type:$2", $file)
+			push_parameter($1, "$type:$2", $file, $declaration_name)
 		    }
 		}
 		else {
 		    save_struct_actual($param);
-		    push_parameter($param, $type, $file);
+		    push_parameter($param, $type, $file, $declaration_name);
 		}
 	    }
 	}
     }
 }
 
-sub push_parameter($$$) {
+sub push_parameter($$$$) {
 	my $param = shift;
 	my $type = shift;
 	my $file = shift;
+	my $declaration_name = shift;
 
 	if (($anon_struct_union == 1) && ($type eq "") &&
 	    ($param eq "}")) {
@@ -2442,21 +1411,15 @@ sub push_parameter($$$) {
 	# warn if parameter has no description
 	# (but ignore ones starting with # as these are not parameters
 	# but inline preprocessor statements);
-	# also ignore unnamed structs/unions;
-	if (!$anon_struct_union) {
+	# Note: It will also ignore void params and unnamed structs/unions
 	if (!defined $parameterdescs{$param} && $param !~ /^#/) {
+		$parameterdescs{$param} = $undescribed;
 
-	    $parameterdescs{$param} = $undescribed;
-
-	    if (($type eq 'function') || ($type eq 'enum')) {
-		print STDERR "${file}:$.: warning: Function parameter ".
-		    "or member '$param' not " .
-		    "described in '$declaration_name'\n";
-	    }
-	    print STDERR "${file}:$.: warning:" .
-			 " No description found for parameter '$param'\n";
-	    ++$warnings;
-	}
+	        if (show_warnings($type, $declaration_name)) {
+			print STDERR
+			      "${file}:$.: warning: Function parameter or member '$param' not described in '$declaration_name'\n";
+			++$warnings;
+		}
 	}
 
 	$param = xml_escape($param);
@@ -2475,8 +1438,8 @@ sub push_parameter($$$) {
 	$parametertypes{$param} = $type;
 }
 
-sub check_sections($$$$$$) {
-	my ($file, $decl_name, $decl_type, $sectcheck, $prmscheck, $nested) = @_;
+sub check_sections($$$$$) {
+	my ($file, $decl_name, $decl_type, $sectcheck, $prmscheck) = @_;
 	my @sects = split ' ', $sectcheck;
 	my @prms = split ' ', $prmscheck;
 	my $err;
@@ -2510,14 +1473,6 @@ sub check_sections($$$$$$) {
 					"'$sects[$sx]' " .
 					"description in '$decl_name'\n";
 				++$warnings;
-			} else {
-				if ($nested !~ m/\Q$sects[$sx]\E/) {
-				    print STDERR "${file}:$.: warning: " .
-					"Excess $decl_type member " .
-					"'$sects[$sx]' " .
-					"description in '$decl_name'\n";
-				    ++$warnings;
-				}
 			}
 		}
 	}
@@ -2621,14 +1576,14 @@ sub dump_function($$) {
 	$declaration_name = $2;
 	my $args = $3;
 
-	create_parameterlist($args, ',', $file);
+	create_parameterlist($args, ',', $file, $declaration_name);
     } else {
 	print STDERR "${file}:$.: warning: cannot understand function prototype: '$prototype'\n";
 	return;
     }
 
 	my $prms = join " ", @parameterlist;
-	check_sections($file, $declaration_name, "function", $sectcheck, $prms, "");
+	check_sections($file, $declaration_name, "function", $sectcheck, $prms);
 
         # This check emits a lot of warnings at the moment, because many
         # functions don't have a 'Return' doc section. So until the number
@@ -2697,7 +1652,7 @@ sub tracepoint_munge($) {
 sub syscall_munge() {
 	my $void = 0;
 
-	$prototype =~ s@[\r\n\t]+@ @gos; # strip newlines/CR's/tabs
+	$prototype =~ s@[\r\n]+@ @gos; # strip newlines/CR's
 ##	if ($prototype =~ m/SYSCALL_DEFINE0\s*\(\s*(a-zA-Z0-9_)*\s*\)/) {
 	if ($prototype =~ m/SYSCALL_DEFINE0/) {
 		$void = 1;
@@ -2802,7 +1757,7 @@ sub process_proto_type($$) {
 # just before actual output; (this is done by local_unescape())
 sub xml_escape($) {
 	my $text = shift;
-	if (($output_mode eq "text") || ($output_mode eq "man")) {
+	if ($output_mode eq "man") {
 		return $text;
 	}
 	$text =~ s/\&/\\\\\\amp;/g;
@@ -2814,7 +1769,7 @@ sub xml_escape($) {
 # xml_unescape: reverse the effects of xml_escape
 sub xml_unescape($) {
 	my $text = shift;
-	if (($output_mode eq "text") || ($output_mode eq "man")) {
+	if ($output_mode eq "man") {
 		return $text;
 	}
 	$text =~ s/\\\\\\amp;/\&/g;
@@ -2827,7 +1782,7 @@ sub xml_unescape($) {
 # local escape strings look like:  '\\\\menmonic:' (that's 4 backslashes)
 sub local_unescape($) {
 	my $text = shift;
-	if (($output_mode eq "text") || ($output_mode eq "man")) {
+	if ($output_mode eq "man") {
 		return $text;
 	}
 	$text =~ s/\\\\\\\\lt:/</g;
@@ -2896,6 +1851,8 @@ sub process_file($) {
 	while (s/\\\s*$//) {
 	    $_ .= <IN>;
 	}
+	# Replace tabs by spaces
+        while ($_ =~ s/\t+/' ' x (length($&) * 8 - length($`) % 8)/e) {};
 	if ($state == STATE_NORMAL) {
 	    if (/$doc_start/o) {
 		$state = STATE_NAME;	# next line is always the function name
@@ -2995,8 +1952,7 @@ sub process_file($) {
 		$in_purpose = 0;
 		$contents = $newcontents;
                 $new_start_line = $.;
-		while ((substr($contents, 0, 1) eq " ") ||
-		       substr($contents, 0, 1) eq "\t") {
+		while (substr($contents, 0, 1) eq " ") {
 		    $contents = substr($contents, 1);
 		}
 		if ($contents ne "") {
@@ -3065,8 +2021,7 @@ sub process_file($) {
 		$contents = $2;
                 $new_start_line = $.;
 		if ($contents ne "") {
-		    while ((substr($contents, 0, 1) eq " ") ||
-		           substr($contents, 0, 1) eq "\t") {
+		    while (substr($contents, 0, 1) eq " ") {
 			$contents = substr($contents, 1);
 		    }
 		    $contents .= "\n";
@@ -3143,38 +2098,12 @@ sub process_file($) {
 	}
     }
     if ($initial_section_counter == $section_counter) {
-	print STDERR "${file}:1: warning: no structured comments found\n";
+	if ($output_mode ne "none") {
+	    print STDERR "${file}:1: warning: no structured comments found\n";
+	}
 	if (($output_selection == OUTPUT_INCLUDE) && ($show_not_found == 1)) {
 	    print STDERR "    Was looking for '$_'.\n" for keys %function_table;
 	}
-	if ($output_mode eq "xml") {
-	    # The template wants at least one RefEntry here; make one.
-	    print "<refentry>\n";
-	    print " <refnamediv>\n";
-	    print "  <refname>\n";
-	    print "   ${orig_file}\n";
-	    print "  </refname>\n";
-	    print "  <refpurpose>\n";
-	    print "   Document generation inconsistency\n";
-	    print "  </refpurpose>\n";
-	    print " </refnamediv>\n";
-	    print " <refsect1>\n";
-	    print "  <title>\n";
-	    print "   Oops\n";
-	    print "  </title>\n";
-	    print "  <warning>\n";
-	    print "   <para>\n";
-	    print "    The template for this document tried to insert\n";
-	    print "    the structured comment from the file\n";
-	    print "    <filename>${orig_file}</filename> at this point,\n";
-	    print "    but none was found.\n";
-	    print "    This dummy section is inserted to allow\n";
-	    print "    generation to continue.\n";
-	    print "   </para>\n";
-	    print "  </warning>\n";
-	    print " </refsect1>\n";
-	    print "</refentry>\n";
-	}
     }
 }
 
@@ -3225,4 +2154,4 @@ if ($verbose && $warnings) {
   print STDERR "$warnings warnings\n";
 }
 
-exit($errors);
+exit($output_mode eq "none" ? 0 : $errors);
-- 
2.14.3
